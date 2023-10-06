output "client_access_policy_id" {
  description = "The ID of the access policy created for the client."
  value       = azurerm_key_vault_access_policy.client_access[0].id
}

output "client_access_policy_key_permissions" {
  description = "The key permissions granted to the client by the access policy."
  value       = azurerm_key_vault_access_policy.client_access[0].key_permissions
}

output "key_vault_ids" {
  description = "The IDs of the created Key Vaults."
  value       = { for vault, key_vault in azurerm_key_vault.keyvault : vault => key_vault.id }
}

output "key_vault_locations" {
  description = "The locations of the created Key Vaults."
  value       = { for vault, key_vault in azurerm_key_vault.keyvault : vault => key_vault.location }
}

output "key_vault_names" {
  description = "The names of the created Key Vaults."
  value       = { for vault, key_vault in azurerm_key_vault.keyvault : vault => key_vault.name }
}
