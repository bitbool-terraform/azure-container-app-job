output "id" {
  value = resource.azurerm_container_app_job.container_app_job.id
}
# output "ingress" {
#   value = resource.azurerm_container_app.container_app.ingress
# }
# output "app_fqdn" {
#   value = resource.azurerm_container_app.container_app.ingress[0].fqdn
# }

# output "latest_revision_fqdn" {
#   value = resource.azurerm_container_app_job.container_app_job.latest_revision_fqdn
# }
# output "latest_revision_name" {
#   value = resource.azurerm_container_app_job.container_app_job.latest_revision_name
# }

output "secrets_selected" {
  value = local.secrets_selected
}
output "secrets_selected_all" {
  value = local.secrets_selected_all
}
output "secrets_selected_all_ids" {
  value = local.secrets_selected_all_ids
}

output "secrets_imported_all" {
  value = local.secrets_imported_all
}
output "secrets_imported_all_ids" {
  value = local.secrets_imported_all_ids
}
output "secrets_all" {
  value = local.secrets_all
}
