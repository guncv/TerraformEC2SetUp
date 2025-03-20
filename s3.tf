resource "aws_s3_bucket" "wordpress_s3" {
  bucket = var.bucket_name
  force_destroy = true

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_public_access_block" "wordpress_media_block" {
  bucket = aws_s3_bucket.wordpress_s3.id
  block_public_acls       = false  
  block_public_policy     = false  
  ignore_public_acls      = false
  restrict_public_buckets = false  
}

resource "aws_s3_bucket_policy" "wordpress_s3_policy" {
  bucket = aws_s3_bucket.wordpress_s3.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.bucket_name}/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.wordpress_ec2_role.arn}"
      },
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket",
        "s3:DeleteObject",
        "s3:GetBucketLocation"
      ],
      "Resource": [
        "arn:aws:s3:::${var.bucket_name}",
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_s3_bucket_versioning" "wordpress_s3_versioning" {
  bucket = aws_s3_bucket.wordpress_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}
