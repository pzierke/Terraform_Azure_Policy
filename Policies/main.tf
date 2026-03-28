resource "azurerm_policy_definition" "require_environment_tag" {
  name         = "require-environment-tag-lab"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Require Environment tag (Lab)"
  description  = "Audits resources that do not have an Environment tag."

  metadata = jsonencode({
    category = "Tags"
    version  = "1.0.0"
  })

  parameters = jsonencode({
    tagName = {
      type = "String"
      metadata = {
        displayName = "Tag Name"
        description = "Name of the required tag"
      }
      defaultValue = "Environment"
    }
  })

  policy_rule = jsonencode({
    if = {
      field  = "[concat('tags[', parameters('tagName'), ']')]"
      exists = "false"
    }
    then = {
      effect = "audit"
    }
  })
}

resource "azurerm_subscription_policy_assignment" "require_environment_tag_assignment" {
  name                 = "require-environment-tag-lab-assignment"
  subscription_id      = "/subscriptions/${var.subscription_id}"
  policy_definition_id = azurerm_policy_definition.require_environment_tag.id
  display_name         = "Require Environment tag (Lab Assignment)"
  description          = "Lab assignment for testing a custom Azure Policy."

  parameters = jsonencode({
    tagName = {
      value = "Environment"
    }
  })
}
