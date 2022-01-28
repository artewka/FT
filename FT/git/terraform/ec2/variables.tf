#default instance type
variable "instance_type" {
    default     = "t2.micro"
    description = "ec2-instance type"
}

#default IAM role
variable "iam_instance_profile" {
    default     = "EC2_SSM"
    description = "ec2-iam role"
}

#subnet id for ec2 instance
variable "subnet_id" {
}

#security group for ec2 instance
variable "security_group" {
}

#user data path for ec2 instance
variable "user_data" {
}

#ssh-key for ec2 instance
variable "key_name" {
}

#tag name for ec2 instance
variable "srv" {
}
