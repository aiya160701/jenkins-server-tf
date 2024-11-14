variable "github_web_ipv4_addresses" {
  description = "Github Webhook IPv4 addresses"
  type        = set(string)
  default = [
    "192.30.252.0/22",
    "185.199.108.0/22",
    "140.82.112.0/20",
    "143.55.64.0/20"
  ]
}

variable "github_web_ipv6_addresses" {
  description = "Github Webhook IPv6 addresses"
  type        = set(string)
  default = [
    "2a0a:a440::/29",
    "2606:50c0::/32"
  ]
}

variable "aKumo_ip_address" {
  default = "73.74.183.123/32"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "jenkins_server_custom_ami" {
  description = "This is pre-configured ami for Jenkins Server with NGINX Proxy "
  default     = "ami-0699aedaa3d0ea70f"
}

variable "jenkins_public_key" {
  type      = string
  sensitive = true
}

