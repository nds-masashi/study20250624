#EC2セキュリティーグループ
resource "aws_security_group" "allow_ssh_ec2_public_sg" {
  name        = "allow-ssh-ec2-public-sg"
  description = "Allow ssh ec2 public sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.specificAddress]
    description = "ssh"
  }

  tags = {
    Name = "${var.resourceName}-public-ec2-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "public_ssh_rule" {
  security_group_id = aws_security_group.allow_ssh_ec2_public_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "ssh"
}

resource "aws_vpc_security_group_egress_rule" "public_https_rule" {
  security_group_id = aws_security_group.allow_ssh_ec2_public_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "https"
}

#EC2インスタンス
resource "aws_instance" "ec2_instance_public" {
  ami                    = "ami-0e2612a08262410c8" # AmazonLinux
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_ec2_public_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  key_name               = "aws-eb"

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "${var.resourceName}-public-instance"
  }
}
