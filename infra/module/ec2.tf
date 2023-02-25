resource "aws_instance" "app_ec2_primary" {
  #checkov:skip=CKV_AWS_126:no need for detailed monitoring
  #checkov:skip=CKV_AWS_135:ubuntu x86 not ebs optimizable
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t2.small"
  availability_zone    = aws_subnet.app_subnet_public.availability_zone
  subnet_id            = aws_subnet.app_subnet_public.id
  iam_instance_profile = aws_iam_instance_profile.app_ec2_iam_inst_prof.name
  ebs_optimized        = false

  user_data = <<EOF
#!/bin/bash
apt update && apt upgrade -y
apt install ansible git python3-pip -y
pip3 install boto3
pip3 install botocore
ansible-galaxy collection install amazon.aws
ansible-galaxy collection install community.aws
EOF

  vpc_security_group_ids = [
    aws_security_group.app_sg_ec2.id
  ]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
    encrypted   = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      ami
    ]
  }

  tags = {
    Name = "${lower(var.app_name)}-botdr-ec2"
  }
}

resource "aws_iam_instance_profile" "app_ec2_iam_inst_prof" {
  name = "${lower(var.app_name)}-ec2-iam-inst-prof"
  role = aws_iam_role.app_ec2_iam_role.name
}
