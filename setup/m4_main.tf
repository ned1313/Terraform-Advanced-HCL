resource "aws_lb" "web" {
  internal           = false
  load_balancer_type = "network"
  subnets            = aws_subnet.public[*].id

  tags = merge(local.common_tags, {
    Name = format("%s-nlb", local.name_prefix)
  })
}

resource "aws_lb_target_group" "web" {
  port        = "" # From application config variable
  protocol    = "" # From application config variable, should be TCP
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    protocol = "" # From application config variable, should be HTTP
    port     = "" # From application config variable
    path     = "" # From application config variable
  }

  tags = merge(local.common_tags, {
    Name = format("%s-nlb-tg", local.name_prefix)
  })
}

resource "aws_lb_target_group_attachment" "nlb_targets" {
  count = "" # From application config variable

  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web[count.index].id
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.web.arn
  port              = "" # From application config variable
  protocol          = "" # From application config variable, should be TCP

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}