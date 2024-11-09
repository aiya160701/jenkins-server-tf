#VPC
import {
  to = aws_vpc.server
  id = "vpc-01497ba091d856410"
}

#PUBLIC SUBNET
import {
  to = aws_subnet.public_subnet
  id = "subnet-0b9dcd2a733f107c5"
}

#PRIVATE SUBNET
import {
  to = aws_subnet.private_subnet
  id = "subnet-0f96946f73ddfe0f8"
}

#IGW
import {
  to = aws_internet_gateway.igw
  id = "igw-0e19cc6c7e350eb83"
}

#PUBLIC ROUTE TABLE
import {
  to = aws_route_table.pub_route_table
  id = "rtb-001847285bc6bab83" # Replace with your Route Table ID
}

#PRIVATE ROUTE TABLE
import {
  to = aws_route_table.priv_route_table
  id = "rtb-05324e28137d1d652" # Replace with your Route Table ID
}

#PUBLIC ROUTE TABLE ASSOCIATION
import {
  to = aws_route_table_association.pub_rta
  id = "subnet-0b9dcd2a733f107c5/rtb-001847285bc6bab83" # Replace with your Route Table Association ID
}

#PRIVATE ROUTE TABLE ASSOCIATION
import {
  to = aws_route_table_association.priv_rta
  id = "subnet-0f96946f73ddfe0f8/rtb-05324e28137d1d652" # Replace with your Route Table Association ID
}

#SG
import {
  to = aws_security_group.jenkins_prod_sg
  id = "sg-0fc72886d8151bba8" # Replace with your Security Group ID
}

#EC2
import {
  to = aws_instance.jenkins_instance
  id = "i-064b02d4d27444b38" # Replace with your EC2 Instance ID
}

#ROUTE 53 HOSTED ZONE
import {
  to = aws_route53_zone.dns_zone
  id = "Z0286370BY6EE6MQTONF" # Replace with your Route53 Hosted Zone ID
}

#JENKINS.AIYALIDA.COM RECORD
import {
  to = aws_route53_record.dns_record
  id = "Z0286370BY6EE6MQTONF_jenkins.aiyalida.com_A" # Replace with your Route53 Record ID
}

#WWW.JENKINS.AIYALIDA.COM RECORD
import {
  to = aws_route53_record.www_dns_record
  id = "Z0286370BY6EE6MQTONF_www.jenkins.aiyalida.com_A" # Replace with your Route53 Record ID
}
