 resource "aws_key_pair" "ssh_key" {
    key_name   = "ssh_ans"
    public_key = file("ssh_ans.pub")
}