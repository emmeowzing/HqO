Interview Repository
========================

This repository contains my solutions to a number of problems 

Breakdown of this repository -

* `webserver/` - a Helm chart that stands up a horizonally-scaled webserver on a K8s cluster.
* `private_repo_fix/` - a solution to the provided `deployment.yaml` ensuring both that
    1. an image can be pulled from a private ECR repository, and
    2. if the containerized application has a memory leak, it will not consume all of the resources on a node (demonstrating resource constraints).
* `tf_helm_deploy` - used to deploy changes to my Helm chart on a test EKS cluster.

### Steps I've taken to solve these problems

1. Create a test EKS cluster with a node group containing a single worker node (max 2) -
```shell
eksctl create cluster --name hqo --tags "Owner=Brandon" --region us-east-2 --version 1.18 --timeout "60m0s" --nodegroup-name test --node-type t3.medium --nodes-min 1 --nodes-max 2 --node-volume-size 80 --node-labels "env=test" --full-ecr-access --asg-access --alb-ingress-access --auto-kubeconfig
```

2. Apply [Metrics Server](https://github.com/kubernetes-sigs/metrics-server#installation) for HPA.
   
3. Apply the Helm chart with the Terraform in `tf_helm_deploy` to deploy the webserver application on my .

4. 