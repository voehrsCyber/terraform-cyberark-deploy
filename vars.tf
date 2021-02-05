variable "AWS_REGION" { default = "eu-central-1" }
variable "VERSION" { default = 12.0 }
variable "PATH_TO_PRIVATE_KEY" { default = "mykey" }
variable "PATH_TO_PUBLIC_KEY" { default = "mykey.pub" }
variable "INSTANCE_USERNAME" { default = "admin" }
variable "INSTANCE_PASSWORD" {
  type        = string
  description = "This Password is used for a new local admin account"
  default     = "Cyberark1Cyberark!"
}
