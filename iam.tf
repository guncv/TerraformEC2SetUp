resource "aws_iam_role" "wordpress_ec2_role" {
  name = var.wordpress_ec2_role_name

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

### ✅ 3. Create IAM Policy for EC2 to Access S3
### ✅ 3. Create IAM Policy for EC2 to Access S3 + IAM Policy Read Permissions
data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "wordpress_s3_access" {
  name        = var.s3_access_policy_name
  description = "Allows EC2 instances to fully access S3 bucket and IAM role policies"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}",
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:GetRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:GetPolicy",
                "iam:GetPolicyVersion"
            ],
            "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.wordpress_ec2_role_name}"
        }
    ]
}
EOF
}



### ✅ 4. Attach Policy to EC2 Role
resource "aws_iam_role_policy_attachment" "wordpress_s3_attachment" {
  role       = aws_iam_role.wordpress_ec2_role.name
  policy_arn = aws_iam_policy.wordpress_s3_access.arn
}

### ✅ 5. Create IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "wordpress_instance_profile" {
  name = var.wordpress_instance_profile_name
  role = aws_iam_role.wordpress_ec2_role.name
}