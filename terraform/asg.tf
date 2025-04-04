#launch template

resource "aws_launch_template" "my_launch_template" {
  name          = "my-launch-template"
  image_id      = var.primary_ami_id
  key_name      = var.primary_kp
  instance_type = "t2.micro"
  user_data     = base64encode(file("${path.module}/script.sh"))
  depends_on    = [aws_security_group.my_sg]

  #add network interface and assign public ip
  network_interfaces {
    security_groups             = [aws_security_group.my_sg.id] #when network interface is created, it will be assigned to this security group
    associate_public_ip_address = true

  }
}

#auto scaling group
resource "aws_autoscaling_group" "my_asg" {
  name                      = "my-asg"
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  desired_capacity          = 1
  vpc_zone_identifier       = [aws_subnet.my-subnet-1.id, aws_subnet.my-subnet-2.id]
  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }

  #attach to load balancer/target group
  target_group_arns    = [aws_lb_target_group.my_tg.arn]
  health_check_type    = "ELB"
  termination_policies = ["OldestInstance"]
  availability_zone_distribution {
    capacity_distribution_strategy = "balanced-best-effort"
  }

}

#auto scaling group policy
#target tracking scaling policy, set a scaling policy name, metric type is average cpu utilization, target value is 50%

resource "aws_autoscaling_policy" "my_asg_policy" {
  name                      = "my-asg-policy"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 300
  autoscaling_group_name    = aws_autoscaling_group.my_asg.name
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}