# Create EC2 instances
resource "aws_instance" "ec2-one" {
  ami                         = var.ec2_ami
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  subnet_id                   = aws_subnet.public_subnet1.id
  associate_public_ip_address = true
  user_data                   = file("userdata.sh")
  key_name                    = aws_key_pair.ec2_key.key_name
  instance_type               = "t2.micro"
  tags = {
    Name = "webserver-1"
  }
}

resource "aws_instance" "ec2-two" {
  ami                         = var.ec2_ami
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  subnet_id                   = aws_subnet.public_subnet2.id
  user_data                   = file("userdata.sh")
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ec2_key.key_name
  instance_type               = "t2.micro"
  tags = {
    Name = "webserver-2"
  }
}