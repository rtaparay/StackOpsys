<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >=2.35.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >=2.35.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.longhorn](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.longhorn-system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [null_resource.wait_for_ingress_nginx](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [helm_template.reloader](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/data-sources/template) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ingress_nginx_enabled"></a> [ingress\_nginx\_enabled](#input\_ingress\_nginx\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_longhorn_enabled"></a> [longhorn\_enabled](#input\_longhorn\_enabled) | tools | `bool` | `false` | no |
| <a name="input_longhorn_version"></a> [longhorn\_version](#input\_longhorn\_version) | n/a | `string` | `"v1.6.2"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->