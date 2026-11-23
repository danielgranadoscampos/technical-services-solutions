terraform {
  required_version = ">= 1.9"

  # A serverless workspace needs no AWS resources (no VPC, cross-account role or
  # root bucket), so the AWS provider is not required.
  required_providers {
    databricks = {
      source = "databricks/databricks"
      # 1.75 added compute_mode = "SERVERLESS"; 1.104 added the serverless
      # network policy resources used in network_policy.tf.
      version = "~> 1.104"
    }
  }
}
