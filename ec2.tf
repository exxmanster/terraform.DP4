# resource "aws_instance" "foo" {
#   ami           = "ami-005e54dee72cc1d00" # us-west-2
#   instance_type = "t2.micro"
#   subnet_id = aws_subnet.private1.id
#   awsvpc_security_group_ids = aws_security_group.allow_http.id
#   tags = {
#     Name = "Web 1"
#    }
# }