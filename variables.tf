
variable "subject_alternative_names" {
  type = list(string)
}

variable "application" {
  type = string
}
variable "main_hosted_zone_name" {
    type = string
}
variable "hosted_zone_name" {
    type = string
}

variable "ns_record_subdomain" {
    type = string
}
variable "env" {
    type = string
}
variable "service" {
    type = string
}
