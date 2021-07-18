HqO Interview Solutions
=======================

Here's a breakdown of this repository's structure -

* `webserver/` - a Helm chart that stands up a horizonally-scaled web server on a K8s cluster.
* `fixes/` - a Helm chart containing a solution to the provided `deployment.yaml` ensuring both that
    1. an image can be pulled from a private container repository, and
    2. if the containerized application has a memory leak, it will not consume all the resources on a node.
* `terraform/` - used to manage state and aid in testing these Helm charts on a cluster.
* `website/` - hosts a `Dockerfile` I've used to customize `httpd` with TLS/HTTPS enabled (keys intentionally included, since they may be retrieved from the publicly-accessible container image on [Docker Hub](https://hub.docker.com/r/bjd2385/httpd-mod) anyways, and this is only for testing, without a CA).

These solutions have been tested on a local Minikube cluster, and a remote EKS cluster running K8s [v1.19](https://kubernetes.io/releases/). Additionally, I'd like to point out that I've tested with [Terraform v1.0.2](terraform/terraform.tf#L14), so you may need to switch to a more recent version with `tfswitch`, if you're using an earlier version.

### Notes for running locally on Minikube

Upon standing up a local test cluster with Minikube (`minikube start --kubernetes-version=1.19.12`),

1. `metrics-server` is available as an addon -
```shell
$ minikube addons enable metrics-server
```
This has required me to comment-out the `helm_release.metrics_server` resource definition under [`terraform/main.tf`](terraform/main.tf) to get a successful apply. For testing on EKS, however, this block can be left as-is.

2. In order to get the `Service` of type `LoadBalancer` to work on Minikube, in a separate shell I've had to run `minikube tunnel` to get a successful apply. Thereafter, you
should be able to access the website at the external IP listed under `kubectl get svc -n webserver`. Otherwise, the apply times out and an external IP is never assigned.
   
### Additional Configuration/Setup Steps for `fixes/`

To pull from my private DockerHub repository, which hosts the same image as in the public repository, I've taken the following steps on my clusters.

1. Create a secret containing the DockerHub login credential:
```shell
$ read -s -r -p "Password: " passwd; printf "\\n"; k create secret docker-registry personal-docker-private --docker-username=bjd2385 --docker-password="$passwd" --docker-email=bjd2385.linux@gmail.com
Password: 
secret/personal-docker-private created
$ k get secrets
NAME                                   TYPE                                  DATA   AGE
default-token-2494d                    kubernetes.io/service-account-token   3      75m
metrics-server-token-qjhn9             kubernetes.io/service-account-token   3      59m
personal-docker-private                kubernetes.io/dockerconfigjson        1      66s
sh.helm.release.v1.metrics-server.v1   helm.sh/release.v1                    1      59m
```

2. Patch the `default` service account, or create a new one (a much better idea from a security perspective), to grant pods running under this service account access to this secret:
```shell
$ kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "personal-docker-private"}]}'
serviceaccount/default patched
```

3. Uncomment [`terraform/main.tf#L36-43`](terraform/main.tf#L36) and comment-out the former resource block pertaining to the webserver deployment implementation, followed by applying these changes with Terraform.

In my own cluster, I see that the image is pulled successfully and starts:
```shell
$ k describe pod test-server-959dd6866-2qdmh
Name:         test-server-959dd6866-2qdmh
Namespace:    default
...
Containers:
  fixes:
    Container ID:   docker://4e7b380567b1540f26067ae67f27983b34752052573cdda18712d866e3af7f91
    Image:          bjd2385/private-httpd-mod:latest
    Image ID:       docker-pullable://bjd2385/httpd-mod@sha256:5e6c44a5b537db972cc53faf7508d8629e7c906084d79e380e40d7c99b777cf4
    Port:           443/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Sun, 18 Jul 2021 13:10:25 -0400
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:     500m
      memory:  500Mi
    Requests:
      cpu:        200m
      memory:     200Mi
    Liveness:     tcp-socket :443 delay=0s timeout=1s period=10s #success=1 #failure=3
    Readiness:    tcp-socket :443 delay=0s timeout=1s period=10s #success=1 #failure=3
...
```