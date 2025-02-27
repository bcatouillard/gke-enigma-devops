variable "project" {
  description = "GCP Project ID"
  default     = "enigma-devops"
  type        = string
}

variable "region" {
  description = "GCP Region"
  default     = "europe-west3"
  type        = string
}


variable "students" {
  description = "List of email addresses of students"
  type        = list(string)
  default     = []
}
