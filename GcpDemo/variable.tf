variable "region" {
    type = string
    default = "us-west1"
}
variable "project" {
    type = string
    default = "masterarbeit-299622"
}

variable "user" {
    type = string
    default = "new"
}

variable "privatekeypath" {
    type = string
    default = "id_rsa"
}

variable "publickeypath" {
    type = string
    default = "id_rsa.pub"
}

variable "bucket_name" {
    type = string
    default = "storage123432"
}

variable "bucket_location" {
    type = string
    default = "US"
}

variable "redis_display_name" {
    type = string
    default = "redis"
}

variable "redis_location_id" {
    type = string
    default = "us-central1-a"
}


variable "machine_type" {
    type = string
    default = "f1-micro"
}

