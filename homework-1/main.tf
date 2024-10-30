resource "aws_instance" "web" {
  # provider = aws.ohio
  ami                    = "ami-0866a3c8686eaeeba"
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.jenkins-sg]
  user_data              = file("userdata.sh")
  key_name               = aws_key_pair.my-key.key_name
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "jenkins-server" #string interpolation
  }

}

resource "aws_key_pair" "my-key" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

