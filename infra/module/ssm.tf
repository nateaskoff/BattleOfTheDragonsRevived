resource "aws_ssm_association" "app_ssm_ans_ensure_nwserver_user" {
  name                        = "AWS-ApplyAnsiblePlaybooks"
  association_name            = "${lower(var.app_name)}-ssm-ans-ensure-nwserver-user"
  schedule_expression         = "cron(0/30 * * * ? *)"
  apply_only_at_cron_interval = true

  targets {
    key = "InstanceIds"
    values = [
      aws_instance.app_ec2_primary.id
    ]
  }

  output_location {
    s3_bucket_name = aws_s3_bucket.app_s3_logs_bucket.bucket
    s3_key_prefix  = "Ansible/${var.app_name}/nw_ensure_nwserver_user"
  }

  parameters = {
    SourceType          = "S3"
    SourceInfo          = <<EOF
{
    "path":"https://${aws_s3_bucket.app_s3_code_bucket.bucket}.s3.amazonaws.com/Ansible/"
}
EOF
    InstallDependencies = "True"
    PlaybookFile        = "app-anspb-ensure-nwserver-user.yml"
    ExtraVariables      = "SSM=True"
    Check               = "False"
    Verbose             = "-v"
  }
}

resource "aws_ssm_association" "app_ssm_ans_ensure_nwserver_files" {
  name                        = "AWS-ApplyAnsiblePlaybooks"
  association_name            = "${lower(var.app_name)}-ssm-ans-ensure-nwserver-files"
  schedule_expression         = "cron(0/30 * * * ? *)"
  apply_only_at_cron_interval = true

  targets {
    key = "InstanceIds"
    values = [
      aws_instance.app_ec2_primary.id
    ]
  }

  output_location {
    s3_bucket_name = aws_s3_bucket.app_s3_logs_bucket.bucket
    s3_key_prefix  = "Ansible/${var.app_name}/nw_ensure_nwserver_files"
  }

  parameters = {
    SourceType          = "S3"
    SourceInfo          = <<EOF
{
    "path":"https://${aws_s3_bucket.app_s3_code_bucket.bucket}.s3.amazonaws.com/Ansible/"
}
EOF
    InstallDependencies = "True"
    PlaybookFile        = "app-anspb-ensure-nwserver-files.yml"
    ExtraVariables      = "SSM=True"
    Check               = "False"
    Verbose             = "-v"
  }
}

resource "aws_ssm_association" "app_ssm_ans_nwserver_first_run" {
  name                        = "AWS-ApplyAnsiblePlaybooks"
  association_name            = "${lower(var.app_name)}-ssm-ans-nwserver-first-run"
  schedule_expression         = "cron(0/30 * * * ? *)"
  apply_only_at_cron_interval = true

  targets {
    key = "InstanceIds"
    values = [
      aws_instance.app_ec2_primary.id
    ]
  }

  output_location {
    s3_bucket_name = aws_s3_bucket.app_s3_logs_bucket.bucket
    s3_key_prefix  = "Ansible/${var.app_name}/nw_server_first_run"
  }

  parameters = {
    SourceType          = "S3"
    SourceInfo          = <<EOF
{
    "path":"https://${aws_s3_bucket.app_s3_code_bucket.bucket}.s3.amazonaws.com/Ansible/"
}
EOF
    InstallDependencies = "True"
    PlaybookFile        = "app-anspb-nwserver-first-run.yml"
    ExtraVariables      = "SSM=True"
    Check               = "False"
    Verbose             = "-v"
  }
}

resource "aws_ssm_association" "app_ssm_ans_nwserver_service" {
  name                        = "AWS-ApplyAnsiblePlaybooks"
  association_name            = "${lower(var.app_name)}-ssm-ans-nwserver-service"
  schedule_expression         = "cron(0/30 * * * ? *)"
  apply_only_at_cron_interval = true

  targets {
    key = "InstanceIds"
    values = [
      aws_instance.app_ec2_primary.id
    ]
  }

  output_location {
    s3_bucket_name = aws_s3_bucket.app_s3_logs_bucket.bucket
    s3_key_prefix  = "Ansible/${var.app_name}/nw_server_service"
  }

  parameters = {
    SourceType          = "S3"
    SourceInfo          = <<EOF
{
    "path":"https://${aws_s3_bucket.app_s3_code_bucket.bucket}.s3.amazonaws.com/Ansible/"
}
EOF
    InstallDependencies = "True"
    PlaybookFile        = "app-anspb-nwserver-service.yml"
    ExtraVariables      = "SSM=True AWS_ENV='${lower(var.app_name)}' NW_MODULE_NAME='Battle Of The Dragons Revived' NW_SERVER_NAME='${var.nw_server_name}'"
    Check               = "False"
    Verbose             = "-v"
  }
}

resource "aws_ssm_association" "app_ssm_ans_nwserver_module_mgr" {
  name                        = "AWS-ApplyAnsiblePlaybooks"
  association_name            = "${lower(var.app_name)}-ssm-ans-nwserver-module-manager"
  schedule_expression         = "cron(0/30 * * * ? *)"
  apply_only_at_cron_interval = true

  targets {
    key = "InstanceIds"
    values = [
      aws_instance.app_ec2_primary.id
    ]
  }

  output_location {
    s3_bucket_name = aws_s3_bucket.app_s3_logs_bucket.bucket
    s3_key_prefix  = "Ansible/${var.app_name}/nw_server_module_manager"
  }

  parameters = {
    SourceType          = "S3"
    SourceInfo          = <<EOF
{
    "path":"https://${aws_s3_bucket.app_s3_code_bucket.bucket}.s3.amazonaws.com/Ansible/"
}
EOF
    InstallDependencies = "True"
    PlaybookFile        = "app-anspb-nwserver-module-mgr.yml"
    ExtraVariables      = "SSM=True AWS_ENV='${lower(var.app_name)}'"
    Check               = "False"
    Verbose             = "-v"
  }
}

resource "aws_ssm_association" "app_ssm_ans_run_system_updates" {
  name                        = "AWS-ApplyAnsiblePlaybooks"
  association_name            = "${lower(var.app_name)}-ssm-ans-run-system-updates"
  schedule_expression         = "cron(15 1 ? * WED *)"
  apply_only_at_cron_interval = true

  targets {
    key = "InstanceIds"
    values = [
      aws_instance.app_ec2_primary.id
    ]
  }

  output_location {
    s3_bucket_name = aws_s3_bucket.app_s3_logs_bucket.bucket
    s3_key_prefix  = "Ansible/${var.app_name}/nw_run_system_updates"
  }

  parameters = {
    SourceType          = "S3"
    SourceInfo          = <<EOF
{
    "path":"https://${aws_s3_bucket.app_s3_code_bucket.bucket}.s3.amazonaws.com/Ansible/"
}
EOF
    InstallDependencies = "True"
    PlaybookFile        = "app-anspb-run-system-updates.yml"
    ExtraVariables      = "SSM=True"
    Check               = "False"
    Verbose             = "-v"
  }
}
