resource "aws_instance" "app" {
  count = var.instacne_count 
  ami           = data.aws_ami.awsn2_ami.id 
  instance_type = var.instance_type 
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name  =   var.key_pairs 
  subnet_id = var.private_subnets[count.index % length(var.private_subnets)]
  iam_instance_profile = aws_iam_instance_profile.profile-app.name

  tags = {
    Name = "app-${count.index}"
    Environment = var.env
  }
  
}


resource "aws_security_group" "app_sg" {
  name        = "app_sg"   
  description = "Allow SSH and 80 traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_host_sg.id] 
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [var.alb_sg] 
  }

    ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    security_groups = [var.alb_sg] 
  }

    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#----------------------------------------------------App Instance

#----------------------------------------------------Bastion Host

resource "aws_instance" "bastion_host"{
    ami           = data.aws_ami.awsn2_ami.id 
    key_name    =   var.key_pairs 
    vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]
    subnet_id   = var.public_subnets[0]
    instance_type   =   var.instance_type
    iam_instance_profile = aws_iam_instance_profile.profile-app.name

    tags = {
    Name = "bastion_host"
  }


  provisioner "file" {
    content   = var.path_private_key
    destination = "/home/ec2-user/private-key.pem"  

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"                     
      private_key = var.path_private_key
    }
  }

   provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/ec2-user/private-key.pem"
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = var.path_private_key
    }
  }

}


resource "aws_security_group" "bastion_host_sg" {
  name        = "bastion_host_sg"   
  description = "Allow SSH"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # IP of the private computer 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#---------------------------------------------------------------------------------IAM


resource "aws_iam_role_policy_attachment" "attach_policy_with_role" {
  role       = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.app_policy.arn
}


resource "aws_iam_role" "app_role" {
  name = "app_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"  
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}


resource "aws_iam_policy" "app_policy" {
  name = "app_policy"

  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1729157299571",
      "Action": "dynamodb:*",
      "Effect": "Allow",
      "Resource": var.dynamodb_arn
    },
    {
        Effect = "Allow"
        Action = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchGetImage",
        "ecr:GetRepositoryPolicy",
        "ecr:Pull",
        "ecr:DescribeImages",
        "ecr:GetDownloadUrlForLayer"
      ]
        Resource = "*"
    },
    {
        Effect = "Allow"
        Action =["secretsmanager:GetSecretValue"]
        Resource = "arn:aws:secretsmanager:eu-north-1:590183945610:secret:StockKey_output-G4jy3z"
    }
  ]
})
}

resource "aws_iam_instance_profile" "profile-app" {
  name = "profile-app"
  role = aws_iam_role.app_role.name 
}


resource "aws_iam_role_policy_attachment" "ssm_core" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.app_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_instance_core" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.app_role.name
}