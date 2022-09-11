data "kubernetes_service" "ingress_svc" {
  metadata {
    name = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}

resource "kubernetes_namespace" "playground" {
  metadata {
    name = "playground"
  }
}

resource "helm_release" "btn" {
  name                        = var.btn_release_name
  repository                  = var.btn_repository
  chart                       = var.btn_chart
  namespace                   = var.namespace
}

output "homepage_http" {
  value = "http://${var.btn_host}:${data.kubernetes_service.ingress_svc.spec[0].port.0.node_port}"
}

output "homepage_https" {
  value = "https://${var.btn_host}:${data.kubernetes_service.ingress_svc.spec[0].port.1.node_port}"
}