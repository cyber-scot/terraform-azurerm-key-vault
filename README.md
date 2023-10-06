
```hcl
data "azurerm_client_config" "current_client" {
  count = var.use_current_client == true ? 1 : 0
}

resource "azurerm_key_vault_access_policy" "client_access" {
  count        = var.use_current_client == true && var.give_current_client_full_access == true ? 1 : 0
  key_vault_id = azurerm_key_vault.keyvault[0].id # Adjust index based on which key vault the policy should apply to
  tenant_id    = element(data.azurerm_client_config.current_client.*.tenant_id, 0)
  object_id    = element(data.azurerm_client_config.current_client.*.object_id, 0)

  key_permissions         = tolist(var.full_key_permissions)
  secret_permissions      = tolist(var.full_secret_permissions)
  certificate_permissions = tolist(var.full_certificate_permissions)
  storage_permissions     = tolist(var.full_storage_permissions)
}

resource "azurerm_key_vault" "keyvault" {
  for_each = { for vault, key_vault in var.key_vaults : vault => key_vault }

  name                            = each.value.name
  location                        = each.value.location
  resource_group_name             = each.value.rg_name
  sku_name                        = lower(each.value.sku_name)
  tenant_id                       = var.use_current_client == true ? data.azurerm_client_config.current_client[0].tenant_id : each.value.tenant_id
  enabled_for_deployment          = each.value.enabled_for_deployment
  enabled_for_disk_encryption     = each.value.enabled_for_disk_encryption
  enabled_for_template_deployment = each.value.enabled_for_template_deployment
  enable_rbac_authorization       = each.value.enable_rbac_authorization
  purge_protection_enabled        = each.value.purge_protection_enabled
  soft_delete_retention_days      = each.value.soft_delete_retention_days
  public_network_access_enabled   = each.value.public_network_access_enabled

  dynamic "access_policy" {
    for_each = each.value.access_policy != null ? each.value.access_policy : []
    content {
      tenant_id = access_policy.value.tenant_id
      object_id = access_policy.value.object_id

      key_permissions     = access_policy.value.key_permissions
      secret_permissions  = access_policy.value.secret_permissions
      storage_permissions = access_policy.value.storage_permissions
    }
  }

  dynamic "network_acls" {
    for_each = each.value.network_acls != null ? [each.value.network_acls] : []
    content {
      bypass                     = network_acls.value.bypass
      default_action             = title(network_acls.value.default_action)
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }

  dynamic "contact" {
    for_each = each.value.contact != null ? each.value.contact : []
    content {
      email = contact.value.email
      name  = contact.value.name
      phone = contact.value.phone
    }
  }

  tags = each.value.tags
}
```
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.client_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_client_config.current_client](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_access_policy_certificate_permissions"></a> [client\_access\_policy\_certificate\_permissions](#output\_client\_access\_policy\_certificate\_permissions) | The key permissions of the client access policy. |
| <a name="output_client_access_policy_id"></a> [client\_access\_policy\_id](#output\_client\_access\_policy\_id) | The ID of the client access policy. |
| <a name="output_client_access_policy_key_permissions"></a> [client\_access\_policy\_key\_permissions](#output\_client\_access\_policy\_key\_permissions) | The key permissions of the client access policy. |
| <a name="output_client_access_policy_secret_permissions"></a> [client\_access\_policy\_secret\_permissions](#output\_client\_access\_policy\_secret\_permissions) | The key permissions of the client access policy. |
| <a name="output_key_vault_ids"></a> [key\_vault\_ids](#output\_key\_vault\_ids) | The IDs of the created Key Vaults. |
| <a name="output_key_vault_locations"></a> [key\_vault\_locations](#output\_key\_vault\_locations) | The locations of the created Key Vaults. |
| <a name="output_key_vault_names"></a> [key\_vault\_names](#output\_key\_vault\_names) | The names of the created Key Vaults. |
| <a name="output_key_vault_uris"></a> [key\_vault\_uris](#output\_key\_vault\_uris) | The uris of the created Key Vaults. |
