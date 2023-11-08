# Create a security group for the load balancer
resource "aws_security_group" "lb" {
  name        = "lb-sg-dev"
  description = "Allow http"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description = "allow http"
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
  tags = {
    env = "Dev"
  }
}

# Create a security group for EC2 instances
resource "aws_security_group" "ec2" {
  name        = "web-sg-dev"
  description = "Allow http and ssh"
  vpc_id      = aws_vpc.vpc1.id

  # Allow incoming HTTP traffic from the load balancer security group
  ingress {
    description     = "allow http"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
  }

  # Allow incoming SSH traffic from the load balancer security group
  ingress {
    description     = "allow ssh"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    env = "Dev"
  }
}
