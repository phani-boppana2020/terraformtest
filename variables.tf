variable "subnet_cidr"{
    type = list
    default = ["10.0.1.0/24", "10.0.0.0/24"]
}
variable "instance_count"{
    type = number
    default = 2
}
variable "gcp_region"{
    default = "us-central1"
}
variable "project_id"{
    default = "sb-tf-task"
}
variable "vpc_name"{
    default = "terraform-vpc"
}
variable "firewall_name"{
    default = "terraform-firewall"
}
variable "account_id"{
    default = "terraform-sa"
}
variable "serviceaccount_name"{
    default = "TerraformServiceAccount"
}
variable "bucket_name"{
    default = "terraform-bucket2408"
}
variable "target_group_addition_for_bucket"{
    type = number
    default = 1
}