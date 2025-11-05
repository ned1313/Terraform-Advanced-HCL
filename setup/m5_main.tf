resource "aws_network_acl" "main" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [for subnet in aws_subnet.public : subnet.id]

  tags = merge(local.common_tags, {
    Name = format("%s-nacl", local.name_prefix)
  })
}

# Inbound rules
resource "aws_network_acl_rule" "ingress" {
  for_each       = "" # to be replaced
  network_acl_id = aws_network_acl.main.id
  rule_number    = "" # to be replaced
  egress         = "" # to be replaced
  protocol       = "" # to be replaced
  rule_action    = "" # to be replaced
  cidr_block     = "" # to be replaced
  from_port      = "" # to be replaced
  to_port        = "" # to be replaced
}

resource "aws_network_acl_rule" "egress" {
  for_each       = "" # to be replaced
  network_acl_id = aws_network_acl.main.id
  rule_number    = "" # to be replaced
  egress         = "" # to be replaced
  protocol       = "" # to be replaced
  rule_action    = "" # to be replaced
  cidr_block     = "" # to be replaced
  from_port      = "" # to be replaced
  to_port        = "" # to be replaced
}