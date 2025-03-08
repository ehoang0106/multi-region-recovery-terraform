
variable "primary_region" {
  default = "us-west-1"
}

variable "secondary_region" {
  default = "us-east-1"
  
}

variable "primary_ami_id" {
  default = "ami-094b981da55429bfc"
}

variable "secondary_ami_id" {
  default = "ami-08b5b3a93ed654d19"
  
}


variable "primary_kp" {
  default = "my-kp"
}

variable "secondary_kp" {
  default = "secondary_kp"
}

variable "cert_arn" {
  default = "arn:aws:acm:us-west-1:706572850235:certificate/eac6e688-8e0c-4545-a122-d67d1d7bf04a"
}

variable "cert_arn_secondary" {
  default = "arn:aws:acm:us-east-1:706572850235:certificate/a018f67f-dd15-47f9-986b-db0cd0421bd7"
}

variable "my_zone_id" {
  default = "Z09372142GLGU75DMF3RP"
}

variable "zone_id"{
  default = "Z09372142GLGU75DMF3RP"
}