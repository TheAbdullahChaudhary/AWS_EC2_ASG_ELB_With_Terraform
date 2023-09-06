# ----------------------------------------- Create an Auto Scaling Group -----------------------------------------


# Create an Auto Scaling Group
resource "aws_autoscaling_group" "ec2_asg" {
  name                 = "ec2_asg"
  launch_configuration = aws_launch_configuration.asg_launch_cfg.name
  min_size             = 1
  max_size             = 5
  desired_capacity     = 1
  availability_zones   = ["ap-southeast-2a", "ap-southeast-2b"] # Specify the availability zones in ap-southeast-2
}

# -----------------------------------------Create an aws launch configuration -----------------------------------------

# Create an AWS Launch Configuration
resource "aws_launch_configuration" "asg_launch_cfg" {
  name_prefix     = "ec2-lc-"
  image_id        = "ami-0310483fb2b488153" # Replace with a valid AMI ID in ap-southeast-2
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.allow_tls.id]
  key_name        = aws_key_pair.key_tf.key_name
  # Additional instance configuration options can be added here.
}

# Create a "scale out" policy that adds instances when CPU utilization is high
resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "scale-out-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.ec2_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization" # Adjust this for scaling out
    }

    target_value = 75 # Adjust this threshold as needed for scaling out
  }
}

# Create a "scale in" policy that removes instances when CPU utilization is low
resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "scale-in-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.ec2_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageNetworkIn" # Adjust this for scaling in
    }

    target_value = 30 # Adjust this threshold as needed for scaling in
  }
}





