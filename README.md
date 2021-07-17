HqO Interview Solutions
=======================

Breakdown of this repository -

* `webserver/` - a Helm chart that stands up a horizonally-scaled web server on a K8s cluster.
* `fixes/` - a Helm chart containing a solution to the provided `deployment.yaml` ensuring both that
    1. an image can be pulled from a private container repository, and
    2. if the containerized application has a memory leak, it will not consume all of the resources on a node (demonstrating resource constraints).
* `terraform` - used to manage state and aid in testing my Helm chart on an EKS cluster.

These solutions have been tested on both a local and EKS cluster running Kubernetes v1.18.