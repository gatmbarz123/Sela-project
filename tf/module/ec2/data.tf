data "aws_ami" "awsn2_ami" {
  most_recent = true
  owners      = ["137112412989"] # Amazon owner ID for Amazon Linux AMIs

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"] # Amazon Linux 2 AMI pattern
  }
}

