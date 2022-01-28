variable "prefix" {
  type        = string
  description = "The prefix used to name the vpc, subnets, route tables and routes"
}

variable "environment" {
  type        = string
  description = "The name of the environment this resource is part of i.e. dev, prod etc"
}
