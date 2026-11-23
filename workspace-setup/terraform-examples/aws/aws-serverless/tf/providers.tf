# OAuth M2M (account-level service principal). For terraform plan/apply:
#   export DATABRICKS_AUTH_TYPE=oauth-m2m
#   export DATABRICKS_CLIENT_ID=...
#   export DATABRICKS_CLIENT_SECRET=...   # SP OAuth secret, not a PAT
#   unset DATABRICKS_HOST DATABRICKS_ACCOUNT_ID DATABRICKS_TOKEN
#
# No AWS credentials are needed: this template creates no AWS resources.

# Account-level provider: workspace, metastore assignment, network policy, permission assignment.
provider "databricks" {
  alias      = "mws"
  host       = "https://accounts.cloud.databricks.com"
  account_id = var.databricks_account_id
  auth_type  = "oauth-m2m"
}

# Workspace-level provider: objects inside the new workspace (SQL warehouse).
# The service principal that creates the workspace is automatically a workspace admin.
provider "databricks" {
  alias        = "workspace"
  host         = databricks_mws_workspaces.this.workspace_url
  workspace_id = databricks_mws_workspaces.this.workspace_id
  auth_type    = "oauth-m2m"
}
