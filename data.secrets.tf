data "azurerm_key_vault" "key_vault" {
  for_each = local.secrets_selected

  name                = each.value.key_vault_name
  resource_group_name = var.resource_group
}


data "azurerm_key_vault_secrets" "all_secrets" {
  for_each = { for k,v in local.secrets_selected: k=>v if lookup(v,"import_all",false) == true }

  key_vault_id = data.azurerm_key_vault.key_vault[each.key].id
}


data "azurerm_key_vault_secret" "secret" {
  for_each = local.secrets_selected_all

  name         = each.value.secret_name
  key_vault_id = data.azurerm_key_vault.key_vault[each.value.group].id
}

data "azurerm_key_vault_secret" "secret_imported" {
  for_each = local.secrets_imported_all

  name         = each.value.secret_name
  key_vault_id = data.azurerm_key_vault.key_vault[each.value.group].id
}

