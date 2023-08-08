
data "aws_iam_policy_document" "images_bucket" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.IMAGES_BUCKET_NAME}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.images_bucket_oai.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.IMAGES_BUCKET_NAME}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.images_bucket_oai.iam_arn}"]
    }
  }
}

# priavate ACL S3 bucket 생성
resource "aws_s3_bucket" "images_bucket" {
  bucket = var.IMAGES_BUCKET_NAME
  acl    = "private"

  force_destroy = "true"

  tags = {
    Name = var.IMAGES_BUCKET_NAME
  }
}

# resource "aws_s3_bucket_acl" "images_bucket" {
#   bucket = aws_s3_bucket.images_bucket.id
#   # `private`, `public-read`, `public-read-write`, `aws-exec-read`, `authenticated-read`, `log-delivery-write` 중 하나 선택. 
#   # 기본값은 `private`.
#   # `grant`와 대비되는 속성
#   acl = "private"
# }

# Upload S3 bucket Object
resource "aws_s3_bucket_object" "images_bucket_object" {
  bucket = aws_s3_bucket.images_bucket.id
  key    = var.BUCKET_OBJECT                           #BUCKET_OBJECT = "images/iu.gif"
  source = "./${var.BUCKET_OBJECT}"
  content_type = "image/gif"
}

# S3 bucket과 접근 policy 연결
resource "aws_s3_bucket_policy" "images_bucket_policy" {
  bucket = aws_s3_bucket.images_bucket.id
  policy = data.aws_iam_policy_document.images_bucket.json
}


#############################################################################################################

# origin access identity 생성
resource "aws_cloudfront_origin_access_identity" "images_bucket_oai" {
  comment = "${var.team}_origin_access_identity"
}


###############################################################################
# cloudfront 생성
###############################################################################
# log bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket        = var.LOG_BUCKET_NAME
  force_destroy = true
  tags = {
    Name = var.LOG_BUCKET_NAME
  }
}

resource "aws_s3_bucket_ownership_controls" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "log_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.log_bucket]

  bucket = aws_s3_bucket.log_bucket.id
  acl    = "private"
}

##############################################################################






resource "aws_cloudfront_distribution" "images_cdn" {

  origin {
    domain_name = aws_s3_bucket.images_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.images_bucket.id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.images_bucket_oai.cloudfront_access_identity_path
    }
  }

  logging_config {
    include_cookies = false
    bucket = "${var.LOG_BUCKET_NAME}.s3.amazonaws.com"
    prefix = var.team
  }

  comment = "${var.team}_images_cdn"
  
  enabled             = true
  is_ipv6_enabled     = true
  wait_for_deployment = false #cloudfront status가 deployed전 먼저 terraform apply completed
  default_root_object = var.BUCKET_OBJECT
  price_class         = "PriceClass_All"


  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = var.IMAGES_BUCKET_NAME

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      # 지역별 허용시
      # restriction_type = "whitelist"
      # locations        = ["KR", "US", "CA", "GB", "DE"]
  }
  }

  tags = {
    Name = format("%s-cloudfront", var.team)
  }
}