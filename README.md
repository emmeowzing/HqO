HqO Interview Solutions
=======================

Here's a breakdown of this repository -

* `webserver/` - a Helm chart that stands up a horizonally-scaled web server on a K8s cluster.
* `fixes/` - a Helm chart containing a solution to the provided `deployment.yaml` ensuring both that
    1. an image can be pulled from a private container repository, and
    2. if the containerized application has a memory leak, it will not consume all of the resources on a node (demonstrating resource constraints).
* `terraform/` - used to manage state and aid in testing these Helm charts on a cluster.
* `website/` - hosts a `Dockerfile` I've used to customize `httpd` with TLS enabled.

These solutions have been tested on a local Minikube cluster running K8s v1.21, and a remote EKS cluster running v1.18.
