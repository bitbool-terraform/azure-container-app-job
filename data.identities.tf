data "azurerm_user_assigned_identity" "id" {
for_each = { for k,v in local.secrets_selected: k=>v if lookup(v,"identity",null) != null }

  name                = each.value.identity
  resource_group_name = var.resource_group
}

data "azurerm_user_assigned_identity" "app_id" {
  for_each            = var.identities != null ? toset(local.identities_full_list) : []
  # for_each            = var.identities != null ? toset(var.identities) : []

  name                = each.value
  resource_group_name = var.resource_group
}