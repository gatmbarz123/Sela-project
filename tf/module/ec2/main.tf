resource "aws_instance" "app" {
  count = var.instacne_count 
  ami           = data.aws_ami.ubuntu_ami.id 
  instance_type = var.instance_type 
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name  =   var.key_pairs 
  subnet_id = var.private_subnets[count.index % length(var.private_subnets)]
  
  tags = {
    Name = "app-${count.index}"
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
    cidr_blocks = ["0.0.0.0/0"] # IP of the private computer 
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [var.alb_sg] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}