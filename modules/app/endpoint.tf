#エンドポイント セキュリティーグループ
resource "aws_security_group" "allow_https_ep_sg" {
  name        = "allow-https-ep-sg"
  description = "allow https ep sq"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
    description = "https ec2"
  }

  tags = {
    Name = "${var.resourceName}-ep-sg"
  }
}

# エンドポイント
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_vpc.vpc.default_route_table_id]
}
