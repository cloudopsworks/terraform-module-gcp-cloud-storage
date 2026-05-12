## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 7.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 7.22.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.8.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [google_storage_bucket.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [google_project.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_config"></a> [bucket\_config](#input\_bucket\_config) | The configuration for the Cloud Storage bucket | `any` | `{}` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add to the resources | `map(string)` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Is this a hub or spoke configuration? | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Cloud Storage bucket | `string` | `""` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Creates a unique bucket name beginning with the specified prefix. Conflicts with name | `string` | `""` | no |
| <a name="input_org"></a> [org](#input\_org) | Organization details | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_random_bucket_suffix"></a> [random\_bucket\_suffix](#input\_random\_bucket\_suffix) | Creates a unique bucket name with a random 8 character string appended to the end. Defaults to true, for clean names set to false | `bool` | `true` | no |
| <a name="input_short_system_name"></a> [short\_system\_name](#input\_short\_system\_name) | Force the use of the short system name local variable, defaults to false. | `bool` | `false` | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | Spoke ID Number, must be a 3 digit number | `string` | `"001"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The ID of the Cloud Storage bucket |
| <a name="output_bucket_location"></a> [bucket\_location](#output\_bucket\_location) | The location of the Cloud Storage bucket |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | The name of the Cloud Storage bucket |
| <a name="output_bucket_project"></a> [bucket\_project](#output\_bucket\_project) | The project ID of the Cloud Storage bucket |
| <a name="output_bucket_self_link"></a> [bucket\_self\_link](#output\_bucket\_self\_link) | The URI of the created Cloud Storage bucket |
| <a name="output_bucket_storage_class"></a> [bucket\_storage\_class](#output\_bucket\_storage\_class) | The storage class of the Cloud Storage bucket |
| <a name="output_bucket_url"></a> [bucket\_url](#output\_bucket\_url) | The base URL of the Cloud Storage bucket |
| <a name="output_bucket_versioning_enabled"></a> [bucket\_versioning\_enabled](#output\_bucket\_versioning\_enabled) | Whether versioning is enabled on the Cloud Storage bucket |
| <a name="output_bucket_website_endpoint"></a> [bucket\_website\_endpoint](#output\_bucket\_website\_endpoint) | The website endpoint of the Cloud Storage bucket (if configured) |
