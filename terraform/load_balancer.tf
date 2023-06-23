resource "aws_lb" "kubernetes_nlb" {
  name               = "kubernetes-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.my_subnet.id]
}

resource "aws_lb_target_group" "kubernetes_tg" {
  name     = "kubernetes-tg"
  port     = 6443
  protocol = "TCP"
  vpc_id   = aws_vpc.my_vpc.id
  target_type = "ip"
}

resource "aws_lb_listener" "kubernetes_listener" {
  load_balancer_arn = aws_lb.kubernetes_nlb.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kubernetes_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "kubernetes_tg_attachment" {
  target_group_arn = aws_lb_target_group.kubernetes_tg.arn
  target_id        = "10.0.1.10"
  port             = 6443
}

resource "aws_lb_target_group_attachment" "kubernetes_tg_attachment2" {
  target_group_arn = aws_lb_target_group.kubernetes_tg.arn
  target_id        = "10.0.1.11"
  port             = 6443
}

resource "aws_lb_target_group_attachment" "kubernetes_tg_attachment3" {
  target_group_arn = aws_lb_target_group.kubernetes_tg.arn
  target_id        = "10.0.1.12"
  port             = 6443
}

