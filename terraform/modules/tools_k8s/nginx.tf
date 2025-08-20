# terraform apply -target=helm_release.ingress_nginx
resource "helm_release" "ingress_nginx" {
  count = var.ingress_nginx_enabled ? 1 : 0

  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  version          = "4.12.2"

  set = [
    {
      name  = "controller.externalTrafficPolicy"
      value = "Local"
    },
    {
      name  = "controller.kind"
      value = "DaemonSet"
    },
    {
      name  = "controller.service.annotations.io.cilium/lb-ipam-ips"
      value = "192.168.100.104"
    }
  ]
}

resource "null_resource" "wait_for_ingress_nginx" {
  count = var.ingress_nginx_enabled ? 1 : 0
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    command = <<EOF
      printf "\nWaiting for the nginx ingress controller...\n"
      kubectl wait --namespace ${helm_release.ingress_nginx[0].namespace} \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/component=controller \
        --timeout=90s
    EOF
  }
}

variable "ingress_nginx_enabled" {
  type    = bool
  default = false
}
