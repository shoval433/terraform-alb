resource "aws_security_group" "alb-shoval-sg-iac" {
  name        = "alb-shoval-sg-iac"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.shoval_vpc_iac.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0 
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  tags = {
      "Owner" =	"Shoval.Astamker"
    }
}

resource "aws_lb_target_group" "target-shoval-iac" {
  name        = "target1-shoval-iac"
  # target_type = "alb"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.shoval_vpc_iac.id
  
  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    timeout             = "2"
    interval            = "5" 
    path                = "/"
   }
   depends_on = [
     aws_instance.prod1_shoval_iac,aws_instance.prod2_shoval_iac,aws_vpc.shoval_vpc_iac
    ]
   tags = {
      "Owner" =	"Shoval.Astamker"
    }
}
resource "aws_lb_listener" "http_forward" {
  load_balancer_arn = aws_lb.alb_shoval_iac.arn
  protocol = "HTTP"
  port = "80"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target-shoval-iac.arn
  }
}

# resource "aws_lb_listener_rule" "http_forward" {
#   listener_arn = aws_lb_listener.http.arn
#   priority = 100
#   condition {
#     path_pattern {
#       values = ["/path"]
#     }
#   }
#   action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.target-shoval-iac.arn
#   }
# }



resource "aws_lb_target_group_attachment" "add_proc1_iac" {
  target_group_arn = aws_lb_target_group.target-shoval-iac.arn
  target_id        = aws_instance.prod1_shoval_iac.id
    port           = 80
}

resource "aws_lb_target_group_attachment" "add_proc2_iac" {
  target_group_arn = aws_lb_target_group.target-shoval-iac.arn
  target_id        = aws_instance.prod2_shoval_iac.id
    port           = 80
}


resource "aws_lb" "alb_shoval_iac" {
  name               = "alb1-shoval-iac"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-shoval-sg-iac.id]
  subnets            = [aws_subnet.sub_1_shoval_iac.id,aws_subnet.sub_2_shoval_iac.id]

#   enable_deletion_protection = true

   tags = {
    Environment = "production"
    Owner =	"Shoval.Astamker"
    }
}