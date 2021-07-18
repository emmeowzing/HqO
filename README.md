HqO Interview Solutions
=======================

Here's a breakdown of this repository's structure -

* `webserver/` - a Helm chart that stands up a horizonally-scaled web server on a K8s cluster.
* `fixes/` - a Helm chart containing a solution to the provided `deployment.yaml` ensuring both that
    1. an image can be pulled from a private container repository, and
    2. if the containerized application has a memory leak, it will not consume all the resources on a node.
* `terraform/` - used to manage state and aid in testing these Helm charts on a cluster.
* `website/` - hosts a `Dockerfile` I've used to customize `httpd` with TLS/HTTPS enabled (keys intentionally included, since they may be retrieved from the publicly-accessible container image on [Docker Hub](https://hub.docker.com/r/bjd2385/httpd-mod) anyways, and this is only for testing, without a CA).

These solutions have been tested on a local Minikube cluster and a remote EKS cluster running K8s [v1.19](https://kubernetes.io/releases/).

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

