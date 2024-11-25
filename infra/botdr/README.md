# botdr

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.9.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.75.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.75.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.web_cert](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.web_cert_val](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/acm_certificate_validation) | resource |
| [aws_cloudfront_distribution.cf_dist_botdr_web](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.default](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_cloudfront_response_headers_policy.default](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/cloudfront_response_headers_policy) | resource |
| [aws_cloudwatch_log_group.ecs_log_group](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_default_security_group.default_sg](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/default_security_group) | resource |
| [aws_ecr_lifecycle_policy.ecr_repo_lifecycle_policy](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.ecr_repo](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/ecr_repository) | resource |
| [aws_ecs_cluster.ecs_cluster](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.ecs_service](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.ecs_task_def](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.ecs_task_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ecs_task_policy](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ecs_task_policy_dev_player_pw](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_task_execution_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_task_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_task_policy_dev_player_pw_attachment](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/internet_gateway) | resource |
| [aws_kms_alias.botdr_key_alias](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/kms_alias) | resource |
| [aws_kms_key.botdr_key](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.botdr_key_policy](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/kms_key_policy) | resource |
| [aws_route.primary_route_public_to_igw](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/route) | resource |
| [aws_route53_record.botdr_web](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/route53_record) | resource |
| [aws_route53_record.web_cert_val_record](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/route53_record) | resource |
| [aws_route_table.primary_vpc_route_table](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/route_table) | resource |
| [aws_route_table_association.primary_vpc_route_table_assoc](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/route_table_association) | resource |
| [aws_s3_bucket.mod_bucket](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.web_bucket](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.mod_bucket_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.web_bucket_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.web_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.mod_bucket_acc_blk](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.web_bucket_acc_blk](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.mod_bucket_sse](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.mod_bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/s3_bucket_versioning) | resource |
| [aws_secretsmanager_secret.botdr_dm_password](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.botdr_player_password](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.botdr_dm_password](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.botdr_player_password](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.ecs_security_group](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.tcp_egress_443](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.tcp_egress_53](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.tcp_ingress_443](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.tcp_ingress_53](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.udp_egress_5121](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.udp_ingress_5121](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/security_group_rule) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/subnet) | resource |
| [aws_vpc.primary_vpc](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/resources/vpc) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ecs_task_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_execution_policy_assume](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_policy](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_role_assume](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_role_policy_dev_player_pw](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_web_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/data-sources/region) | data source |
| [aws_route53_zone.botdr_zone](https://registry.terraform.io/providers/hashicorp/aws/5.75.0/docs/data-sources/route53_zone) | data source |

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
