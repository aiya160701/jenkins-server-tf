#VPC
resource "aws_vpc" "server" {
  tags = {
    Name = "jenkins-server-vpc"
  }
}

#PUBLIC SUBNET
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.server.id
  cidr_block = "10.0.0.0/20"
  tags = {
    Name = "jenkins-server-public-subnet"
  }
}

#PRIVATE SUBNET
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.server.id
  cidr_block = "10.0.128.0/20"
  tags = {
    Name = "jenkins-server-private-subnet"
  }
}

#IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.server.id

  tags = {
    Name = "jenkins-server-igw"
  }
}

#PUBLIC ROUTE TABLE
resource "aws_route_table" "pub_route_table" {
  vpc_id = aws_vpc.server.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "jenkins-server-public-rt"
  }
  tags_all = {
    Name = "jenkins-server-public-rt"
  }
}

#PRIVATE ROUTE TABLE
resource "aws_route_table" "priv_route_table" {
  vpc_id = aws_vpc.server.id
  tags = {
    Name = "jenkins-server-private-rt"
  }
  tags_all = {
    Name = "jenkins-server-private-rt"
  }
}

#PUBLIC ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "pub_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.pub_route_table.id
}


#PRIVATE ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "priv_rta" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.priv_route_table.id
}

#SG JENKINS
resource "aws_security_group" "jenkins_prod_sg" {
  vpc_id = aws_vpc.server.id
  lifecycle {
    ignore_changes = [description]
  }
  ingress = [
    {
      cidr_blocks = [
        var.aKumo_ip_address
      ]
      description      = "SSH from aKumo office"
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    },
    {
      cidr_blocks = [
        var.aKumo_ip_address,
            "192.30.252.0/22",
            "185.199.108.0/22",
            "140.82.112.0/20",
            "143.55.64.0/20"
      ]
      description = "Port 443 is open for aKumos office and GitHub WebHooks"
      from_port   = 443
      ipv6_cidr_blocks = [
            "2a0a:a440::/29",
            "2606:50c0::/32"
      ]
      
      prefix_list_ids = []
      protocol        = "tcp"
      security_groups = []
      self            = false
      to_port         = 443
    },
  ]
}


# EC2 Instance WITH CUSTOM AMI
resource "aws_instance" "jenkins_instance" {
  ami                         = var.jenkins_server_custom_ami
  instance_type               = var.instance_type
  key_name                    = "aiya@mac"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnet.id
  security_groups             = [aws_security_group.jenkins_prod_sg.id]
  lifecycle {
    ignore_changes = [security_groups]
  }
  tags = {
    Name = "prod-ready-jenkins-server"
  }
}

#ROUTE 53 HOSTED ZONE
resource "aws_route53_zone" "dns_zone" {
  name    = "jenkins.aiyalida.com"
  comment = "This is public hosted zone for production ready jenkins server"
  tags = {
    "Purpose" = "ProdReadyJenkinsServer"
  }
  tags_all = {
    "Purpose" = "ProdReadyJenkinsServer"
  }
}


#JENKINS.AIYALIDA.COM RECORD
resource "aws_route53_record" "dns_record" {
  zone_id = aws_route53_zone.dns_zone.zone_id
  name    = "jenkins.aiyalida.com"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.jenkins_instance.public_ip]
}


#WWW.JENKINS.AIYALIDA.COM RECORD
resource "aws_route53_record" "www_dns_record" {
  zone_id = aws_route53_zone.dns_zone.zone_id
  name    = "www.jenkins.aiyalida.com"
  type    = "A"
  alias {
    evaluate_target_health = false
    name                   = "jenkins.aiyalida.com"
    zone_id                = "Z0286370BY6EE6MQTONF"
  }
}
