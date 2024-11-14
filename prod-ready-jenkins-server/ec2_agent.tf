resource "aws_instance" "jenkins_agent_test" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = "aiya@mac"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnet.id
  security_groups             = [aws_security_group.jenkins_agent_sg_terraform.id]
  user_data                   = templatefile("userdata.sh", { jenkins_public_key = var.jenkins_public_key })
  #templatefile function lets userdata to fetch the variable
  user_data_replace_on_change = false
  lifecycle {
    ignore_changes = [security_groups]
  }
  tags = {
    Name = "test-jenkins-agent-server"
  }
}

import {
  to = aws_security_group.jenkins_agent_sg_terraform
  id = "sg-090dc5629f2a6b97c"
}

resource "aws_security_group" "jenkins_agent_sg_terraform" {
  vpc_id = aws_vpc.server.id
  lifecycle {
    ignore_changes = [description]
  }
  ingress = [
    {
      cidr_blocks = [
        var.aKumo_ip_address
      ]
      description      = "SSH from aKumos office"
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    },
    {
      cidr_blocks      = []
      description      = "SSH from Jenkins Controller"
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = [aws_security_group.jenkins_prod_sg.id]
      self             = false
      to_port          = 22
    }
  ]
}