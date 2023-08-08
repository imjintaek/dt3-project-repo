resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${var.prefix}-ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}


resource "aws_iam_role" "ssm_role" {
  name = "${var.prefix}-ssm-role"

  assume_role_policy = <<POLICY
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
POLICY
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ssm_role.name
}

resource "aws_iam_role_policy_attachment" "s3full_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.ssm_role.name
}

resource "aws_iam_role_policy_attachment" "codedeployfull_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess"
  role       = aws_iam_role.ssm_role.name
}

resource "aws_iam_role_policy_attachment" "codedeployrole_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.ssm_role.name
}

resource "aws_iam_role_policy_attachment" "cloudwatchfull_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.ssm_role.name
}
