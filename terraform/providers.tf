# locals {
#   kubernetes = {
#     host                   = module.k8s.kube_config.kubernetes_client_configuration.host
#     client_certificate     = base64decode(module.k8s.kube_config.kubernetes_client_configuration.client_certificate)
#     client_key             = base64decode(module.k8s.kube_config.kubernetes_client_configuration.client_key)
#     cluster_ca_certificate = base64decode(module.k8s.kube_config.kubernetes_client_configuration.ca_certificate)
#   }
# }

provider "kubernetes" {
  host                   = local.kubernetes.host
  client_certificate     = local.kubernetes.client_certificate
  client_key             = local.kubernetes.client_key
  cluster_ca_certificate = local.kubernetes.cluster_ca_certificate
}

provider "helm" {
  kubernetes = {
    host                   = local.kubernetes.host
    client_certificate     = local.kubernetes.client_certificate
    client_key             = local.kubernetes.client_key
    cluster_ca_certificate = local.kubernetes.cluster_ca_certificate
  }
}