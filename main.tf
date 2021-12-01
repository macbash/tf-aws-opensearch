resource "aws_elasticsearch_domain" "es_ds" {
  access_policies       = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "es:*",
      "Principal": "*",
      "Effect": "Allow",
      "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/*",
      "Condition": {
        "IpAddress": {"aws:SourceIp": ["49.204.131.229/32"]}
      }
    }
  ]
}
POLICY
  domain_name           = "dev-es"
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "t3.small.elasticsearch"
  }
  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }
  advanced_security_options {
    enabled = true
    internal_user_database_enabled = true
    master_user_options {
              master_user_name     = "admin"
              master_user_password = "Donth@thisp1s"
            }
  }
  tags = {
    Domain = "dev-es"
  }
  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.es_log_group.arn
    log_type                 = "INDEX_SLOW_LOGS"
  }
  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.es_log_group.arn
    log_type                 = "AUDIT_LOGS"
  }
  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.es_log_group.arn
    log_type                 = "ES_APPLICATION_LOGS"
  }
  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.es_log_group.arn
    log_type                 = "SEARCH_SLOW_LOGS"
  }
  node_to_node_encryption {
    enabled = true
  }
  encrypt_at_rest {
    enabled = true
  }
  domain_endpoint_options {
    enforce_https = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }
  depends_on = [
    "aws_iam_service_linked_role.es",
  ]
}
resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}
