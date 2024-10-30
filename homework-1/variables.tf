variable "instance_type" {
  type        = string
  description = "This is instance type"
  default     = "t2.medium"

}

variable "env" {
    default = "homework"
  
}

variable "jenkins-sg"{
    default = "sg-0f3dc7f4ff5cd8af9"
}