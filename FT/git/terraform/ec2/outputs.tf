#Get public ip for ec2
output "public_ip" {
  value = aws_instance.aws_instance.public_ip
}
