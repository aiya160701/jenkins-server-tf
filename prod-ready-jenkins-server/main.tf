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
    Name = "public-rt"
  }
  tags_all = {
    Name = "public-rt"
  }
}

#PRIVATE ROUTE TABLE
resource "aws_route_table" "priv_route_table" {
  vpc_id = aws_vpc.server.id
  tags = {
    Name = "private-rt"
  }
  tags_all = {
    Name = "private-rt"
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
}


# EC2 Instance WITH CUSTOM AMI
resource "aws_instance" "jenkins_instance" {
  ami                         = "ami-0699aedaa3d0ea70f"
  instance_type               = "t2.medium"
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
  ttl     = "15"
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
