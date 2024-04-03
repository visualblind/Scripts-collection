# Create AWS IAM role for AWS NGINX autoscaling tool
resource "aws_iam_role" "main" {
  name               = "aws-nlb-iam-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

# Create AWS IAM role policy for AWS NGINX autoscaling tool
resource "aws_iam_role_policy" "main" {
  name = "aws-nlb-iam-policy"
  role = aws_iam_role.main.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:Describe*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "elasticloadbalancing:Describe*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:ListMetrics",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:Describe*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "autoscaling:Describe*",
      "Resource": "*"
    }
  ]
}
EOF
}

# Set AWS IAM instance profile
resource "aws_iam_instance_profile" "main" {
  name = "aws-nlb-iam-instance-profile"
  role = aws_iam_role.main.name
}
