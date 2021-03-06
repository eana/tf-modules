## AWS NAT INSTANCE
## ----------------------------------------------------------------------------
resource "aws_security_group" "this" {
  name        = var.name
  vpc_id      = var.vpc_id
  description = "Security group for NAT instance ${var.name}"
  tags        = local.common_tags
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.this.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"] # tfsec:ignore:AWS007
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  description       = "Allow all outbound traffic"
}

resource "aws_security_group_rule" "ingress" {
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  cidr_blocks       = var.private_subnets_cidr_blocks
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  description       = "Allo all inbound traffic from all the private subnet CIDR blocks"
}

resource "aws_network_interface" "this" {
  security_groups   = [aws_security_group.this.id]
  subnet_id         = var.public_subnet
  source_dest_check = false
  description       = "ENI for NAT instance ${var.name}"
  tags              = local.common_tags
}

resource "aws_eip" "this" {
  count             = var.enabled ? 1 : 0
  network_interface = aws_network_interface.this.id
  tags              = local.common_tags
}

resource "aws_route" "this" {
  count                  = length(var.private_route_table_ids)
  route_table_id         = var.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.this.id
}

resource "aws_launch_template" "this" {
  name     = var.name
  image_id = var.image_id != "" ? var.image_id : data.aws_ami.this.id
  key_name = var.key_name

  iam_instance_profile {
    arn = aws_iam_instance_profile.this.arn
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.this.id]
    delete_on_termination       = true
  }

  user_data = base64encode(
    templatefile("${path.module}/data/init.sh", {
      eni_id          = aws_network_interface.this.id
      extra_user_data = var.extra_user_data
    })
  )

  description = "Launch template for NAT instance ${var.name}"
  tags = {
    Name = var.name
  }
}

resource "aws_autoscaling_group" "this" {
  name                = var.name
  desired_capacity    = var.enabled ? 1 : 0
  min_size            = var.enabled ? 1 : 0
  max_size            = 1
  vpc_zone_identifier = [var.public_subnet]

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = var.use_spot_instance ? 0 : 1
      on_demand_percentage_above_base_capacity = var.use_spot_instance ? 0 : 100
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.this.id
        version            = "$Latest"
      }
      dynamic "override" {
        for_each = var.instance_types
        content {
          instance_type = override.value
        }
      }
    }
  }

  tags = local.asg_tags

  lifecycle {
    create_before_destroy = true
  }
}
