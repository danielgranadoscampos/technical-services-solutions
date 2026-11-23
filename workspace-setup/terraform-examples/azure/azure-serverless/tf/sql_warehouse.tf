# Optional serverless SQL warehouse to validate the workspace end to end (the serverless
# counterpart of the single-node validation cluster in the classic templates).
resource "databricks_sql_endpoint" "this" {
  count                     = var.create_sql_warehouse ? 1 : 0
  name                      = "${local.workspace_name}-warehouse"
  cluster_size              = var.sql_warehouse_size
  min_num_clusters          = 1
  max_num_clusters          = 1
  auto_stop_mins            = var.sql_warehouse_auto_stop_mins
  enable_serverless_compute = true
  warehouse_type            = "PRO"

  depends_on = [
    databricks_metastore_assignment.this,
    databricks_workspace_network_option.this,
  ]
}
