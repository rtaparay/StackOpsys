resource "kubernetes_namespace" "longhorn-system" {
  count = var.longhorn_enabled ? 1 : 0

  metadata {
    name = "longhorn-system"
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
    }
  }
}

resource "helm_release" "longhorn" {
  depends_on = [kubernetes_namespace.longhorn-system]
  count      = var.longhorn_enabled ? 1 : 0

  create_namespace = true
  name             = "longhorn"
  repository       = "https://charts.longhorn.io/"
  chart            = "longhorn"
  namespace        = "longhorn-system"
  version          = var.longhorn_version

  set = [
    {
      name  = "defaultSettings.defaultDataPath"
      value = "/var/mnt/longhorn"
    }
  ]
}

# tools
variable "longhorn_enabled" {
  type    = bool
  default = false
}
variable "longhorn_version" {
  type    = string
  default = "v1.6.2"
}
