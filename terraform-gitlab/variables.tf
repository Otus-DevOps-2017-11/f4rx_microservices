variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable zone {
  description = "App zone"
  default     = "europe-west1-b"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable "admin_user" {
  description = "Username for admin"
  default = "subadm"
}

variable private_key_path {
  description = "ssh private key"
}

variable "image" {
  description = "image"
  default = "ubuntu-1604-xenial-v20180126"
}
