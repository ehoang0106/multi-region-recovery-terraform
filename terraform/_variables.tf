variable "primary_vpc_name" {
  default = "primary-vpc"
}

variable "secondary_vpc_name" {
  default = "secondary-vpc"
}

variable "primary_region" {
  default = "us-west-1"
}

variable "secondary_region" {
  default = "us-east-1"
  
}

variable "primary_ami_id" {
  default = "ami-094b981da55429bfc"
}


variable "primary_kp" {
  default = "my-kp"
}

variable "cert_arn" {
  default = "arn:aws:acm:us-west-1:706572850235:certificate/eac6e688-8e0c-4545-a122-d67d1d7bf04a"
}

variable "my_zone_id" {
  default = "Z09372142GLGU75DMF3RP"
}