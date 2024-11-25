# infra

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.9.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.75.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_botdr"></a> [botdr](#module\_botdr) | ./botdr | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_botdr_dm_password"></a> [botdr\_dm\_password](#input\_botdr\_dm\_password) | The password for DM access to the BOTDR module | `string` | n/a | yes |
| <a name="input_botdr_player_password"></a> [botdr\_player\_password](#input\_botdr\_player\_password) | The password for player access to the BOTDR module in DEV | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | The environment to deploy to | `string` | n/a | yes |
| <a name="input_github_sha"></a> [github\_sha](#input\_github\_sha) | The SHA of the commit to deploy | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Defines the 2nd octet of the VPC CIDR block | `number` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
