variable "instance_type" { type = string }

variable "ingress_ports" { type = list(number) }
variable "ingress_protocol" { type = string }