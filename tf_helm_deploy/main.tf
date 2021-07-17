# Create a namespace for our resources.
resource "kubernetes_manifest" "namespace" {
  provider = kubernetes-alpha

  manifest = {
    apiVersion = "v1"
    kind       = "Namespace"
    metadata = {
      name = "webserver"
    }
  }
}

# Install Metrics Server on the cluster for HPA.
# https://artifacthub.io/packages/helm/bitnami/metrics-server
resource "helm_release" "metrics_server" {
  provider = helm

  name       = "metrics-server"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  version    = "5.9.0"
}

# Deploy my web server.
resource "helm_release" "webserver" {
  provider = helm

  name      = "basic-webserver"
  chart     = var.webserver_helm_chart_directory
  values    = [file("${var.webserver_helm_chart_directory}/values.yaml")]
  namespace = kubernetes_manifest.namespace.manifest.metadata.name
}