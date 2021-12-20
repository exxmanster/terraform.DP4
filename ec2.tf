
resource "aws_instance" "web1" {
  ami           = "ami-03af6a70ccd8cb578"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private1.id
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  tags = {
    Name = "Web 1"
   }
}
resource "aws_instance" "web2" {
  ami           = "ami-03af6a70ccd8cb578"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private2.id
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  user_data = "${file("nginx-userdata.sh")}"
  tags = {
    Name = "Web 2"
   }
}

resource "aws_instance" "db1" {
  ami           = "ami-03af6a70ccd8cb578"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private1.id
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  user_data = "${file("nginx-userdata.sh")}"
  tags = {
    Name = "db1"
   }
}

resource "aws_instance" "db2" {
  ami           = "ami-03af6a70ccd8cb578"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private2.id
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  user_data = "${file("nginx-db-userdata.sh")}"
  tags = {
    Name = "db2"
   }
}

resource "aws_alb" "main" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = [aws_subnet.public1.id,aws_subnet.public2.id]

  enable_deletion_protection = true


  tags = {
    Name = "Main elb"
  }
}

resource "aws_alb_target_group" "web" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  tags ={
      Name = "Web TG"
  }
}

resource "aws_alb_target_group" "db" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  tags = {
      Name = "DB TG"
  }
}

resource "aws_alb_target_group_attachment" "web1" {
  
  target_group_arn = aws_alb_target_group.web.arn
  target_id        = aws_instance.web1.id
  port             = 80
}
resource "aws_alb_target_group_attachment" "web2" {
  target_group_arn = aws_alb_target_group.web.arn
  target_id        = aws_instance.web2.id
  port             = 80
}

resource "aws_alb_target_group_attachment" "db1" {
  target_group_arn = aws_alb_target_group.db.arn
  target_id        = aws_instance.db1.id
  port             = 80
}

resource "aws_alb_target_group_attachment" "db2" {
  target_group_arn = aws_alb_target_group.db.arn
  target_id        = aws_instance.db2.id
  port             = 80
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_alb.main.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.web.arn
  }
}

# resource "aws_lb_listener" "db" {
#   load_balancer_arn = aws_alb.main.arn
#   port              = "80"
#   protocol          = "HTTP"
#   path              = /
  
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_alb_target_group.db.arn
#   }
# }