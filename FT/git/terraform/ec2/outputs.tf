# output "aws_instance_id" {
#   value = aws_instance.aws_instance[*].id
# }

output "public_ip" {
  value = aws_instance.aws_instance.public_ip
}
