terraform {
  required_version = ">= 1.9"

  required_providers {
    # azurerm_databricks_workspace cannot create a serverless workspace (no compute_mode
    # argument), so the workspace is created with azapi against the ARM API directly.
    # 2.14 embeds the Microsoft.Databricks/workspaces@2026-01-01 schema, so the body is
    # validated at plan time.
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.14"
    }
    # Resource group and tenant lookup only.
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.50"
    }
    databricks = {
      source = "databricks/databricks"
      # 1.104 added the serverless network policy resources used in network_policy.tf.
      version = "~> 1.104"
    }
  }
}
