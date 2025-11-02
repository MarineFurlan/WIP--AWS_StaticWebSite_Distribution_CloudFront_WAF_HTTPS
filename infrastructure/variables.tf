variable "bucket_name" {
  type    = string
  default = "secure-static-website-001"
}

variable "domain" {
  type    = string
  default = "furlan-cloudsecurity.fr"
}

variable "waf_name" {
  type    = string
  default = "prod-web-acl"
}

variable "price_class" {
  type    = string
  default = "PriceClass_100"
}
/*
variable "github_repo" {
  type    = string
  default = "my-org/my-repo"
}

variable "github_branch" {
  type    = string
  default = "main"
}

variable "github_role_name" {
  type    = string
  default = "github-actions-deploy"
}*/
