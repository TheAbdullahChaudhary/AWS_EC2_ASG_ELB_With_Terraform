# # -----------------------------------------Create an aws ALB -----------------------------------------


# Create an Application Load Balancer (ALB)

resource "aws_lb" "app_lb" {
  name                       = "my-app-alb"
  internal                   = false # Set to true if the ALB should be internal
  load_balancer_type         = "application"
  subnets                    = [aws_subnet.asg_subnet_1.id, aws_subnet.asg_subnet_2.id]
  enable_deletion_protection = false # Set to true if you want to enable deletion protection
}

resource "aws_lb_target_group" "app_lb" {
  name        = "aws-tg"
  port        = 80 # Correct the port to the appropriate value for your application
  protocol    = "HTTP"
  vpc_id      = aws_vpc.asg_vpc.id
  target_type = "instance"

  health_check {
    interval            = 30
    path                = "/"
    port                = 80 # Correct this to match your application's health check port
    protocol            = "HTTP"
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}



# Create a listener for the ALB
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
    }
  }
}


# Create a listener rule to forward traffic to the target group
resource "aws_lb_listener_rule" "app_listener_rule" {
  listener_arn = aws_lb_listener.app_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_lb.arn
  }

  condition {
    path_pattern {
      values = ["/"] # You can customize the path pattern as needed
    }
  }
}



