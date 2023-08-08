resource "aws_networkfirewall_firewall_policy" "fwpolicy" {
  name = "${var.prefix}-fwpolicy"
  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    stateless_rule_group_reference {
      priority     = 10
      resource_arn = aws_networkfirewall_rule_group.drop_tcp_test.arn
    }

    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.block_domains.arn
    }
  
  }
  tags = {
    Managed_by = "Terraform"
    Name = "${var.prefix}-fwpolicy"
    team = "${var.tags.team}"
  }
}

resource "aws_networkfirewall_rule_group" "drop_tcp_test" {  
  capacity = 10
  name     = "drop-tcp-test"
  type     = "STATELESS"
  rule_group {
    rules_source {
      stateless_rules_and_custom_actions {
        stateless_rule {
          priority = 1
          rule_definition {
            actions = ["aws:drop"]
            match_attributes {
              protocols = [6] #TCP
              source {
                address_definition = "${var.cloud9_access_cidr}"
              }

              destination {
                address_definition = "${var.vpc_cidr}"
              }

            }
          }
        }
      }
    }
  }
}




resource "aws_networkfirewall_rule_group" "block_domains" {
  capacity = 100
  name     = "block-domains"
  type     = "STATEFUL"
  rule_group {
    rule_variables {
      ip_sets {
        key = "HOME_NET"
        ip_set {
          definition = [var.public_subnets[0].cidr]       ## PUBLIC A SUBNET 테스트용 : X.4.2.0/24 용
        }
      }
    }
    rules_source {
      rules_source_list {
        generated_rules_type = "DENYLIST"
        target_types         = ["HTTP_HOST", "TLS_SNI"]
        targets              = [".naver.com"]              ## block 도메인 대상 입력
      }
    }
  }

}




resource "aws_networkfirewall_firewall" "fw" {
  name                = "${var.prefix}-fw"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.fwpolicy.arn
  vpc_id          =   var.vpc_id

  dynamic "subnet_mapping" {
    for_each = var.subnet_ids[*]

    content {
      subnet_id = subnet_mapping.value
    }
  }
  
  
 tags = {
    Managed_by = "Terraform"
    Name = "${var.prefix}-fw"
    team = "${var.tags.team}"
  }
}

#https://shisho.dev/dojo/providers/aws/Network_Firewall/aws-networkfirewall-firewall/

resource "aws_cloudwatch_log_group" "fw_alert_log_group" {
  name = "/anf/alert"
}

resource "aws_cloudwatch_log_group" "fw_flow_log_group" {
  name = "/anf/flow"
}



resource "aws_networkfirewall_logging_configuration" "example" {
  firewall_arn = aws_networkfirewall_firewall.fw.arn
  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.fw_alert_log_group.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.fw_flow_log_group.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "FLOW"
    }
  }
}