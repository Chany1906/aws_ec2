resource "aws_instance" "web_app" {
  ami           = "ami-020cba7c55df1f615" # ubuntu
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  security_groups = [aws_security_group.web_sg.name]
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              pip3 install flask boto3
              mkdir /app
              cd /app
              aws s3 cp s3://app-code-bucket/app.py .
              aws s3 cp s3://app-code-bucket/templates/index.html .
              python3 app.py &
              EOF
}

resource "aws_security_group" "web_sg" {
  name = "web-sg-${var.suffix}"
  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_iam_role" "ec2_role" {
  name = "rol_ec2_${var.suffix}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "ec2_policy" {
  role = aws_iam_role.ec2_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = ["s3:GetObject", "s3:ListBucket"],
      Resource = ["${var.output_bucket_arn}/*", var.output_bucket_arn]
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "perfil_ec2_${var.suffix}"
  role = aws_iam_role.ec2_role.name
}
