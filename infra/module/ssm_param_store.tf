resource "aws_ssm_parameter" "param_dm_pw" {
  name  = "${lower(var.app_name)}-sec-dm-pw"
  type  = "SecureString"
  value = var.nw_dm_pw
}

resource "aws_ssm_parameter" "param_admin_pw" {
  name  = "${lower(var.app_name)}-sec-admin-pw"
  type  = "SecureString"
  value = var.nw_admin_pw
}
