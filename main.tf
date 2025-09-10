resource "azurerm_container_app_job" "container_app_job" {


  name                         = var.app_name
  location                     = var.location
  resource_group_name          = var.resource_group
  container_app_environment_id = var.container_app_environment_id
  tags                         = var.tags  
  workload_profile_name        = var.workload_profile
  replica_timeout_in_seconds   = var.replica_timeout_in_seconds

  manual_trigger_config {
    parallelism              = var.manual_trigger_config_parallelism
    replica_completion_count = var.replica_completion_count
  }
   
  dynamic "secret" {
    for_each = local.secrets_all

    content {
      name                =  secret.value.secret_name
      identity            =  secret.value.identity_id
      key_vault_secret_id =  secret.value.key_vault_secret_id
    }
  }


  template {

  container {

        name    = var.app_name
        
        image   = var.app_image
        command = var.app_command

        cpu     = var.cpu
        memory  = var.memory



        dynamic "env" {
          for_each = var.app_env

          content {
            name  = env.key
            value = env.value
          }
        }


        dynamic "env" { # secrets
          for_each = local.secrets_all

          content {
            name        = env.value.envvar_name
            secret_name = env.value.secret_name
          }
        }


        dynamic "liveness_probe" {
          for_each = lookup(var.liveness_probe,"enabled",false) == true ? [var.liveness_probe] : []

          content {
            port                    = lookup(var.liveness_probe,"port",var.liveness_probe_defaults.port)
            transport               = lookup(var.liveness_probe,"transport",var.liveness_probe_defaults.transport)
            failure_count_threshold = lookup(var.liveness_probe,"failure_count_threshold",var.liveness_probe_defaults.failure_count_threshold)
            host                    = lookup(var.liveness_probe,"host",null)
            initial_delay           = lookup(var.liveness_probe,"initial_delay",var.liveness_probe_defaults.initial_delay)
            interval_seconds        = lookup(var.liveness_probe,"interval_seconds",var.liveness_probe_defaults.interval_seconds)
            path                    = lookup(var.liveness_probe,"path",var.liveness_probe_defaults.path)
            timeout                 = lookup(var.liveness_probe,"timeout",var.liveness_probe_defaults.timeout)

            dynamic "header" {
              for_each = lookup(var.liveness_probe,"headers",null) != null ? var.liveness_probe.headers : {}

              content {
                name  = header.value.name
                value = header.value.value
              }
            }
          }
        }

        dynamic "readiness_probe" {
          for_each = lookup(var.readiness_probe,"enabled",false) == true ? [var.readiness_probe] : []

          content {
            port                    = lookup(var.readiness_probe,"port",var.readiness_probe_defaults.port)
            transport               = lookup(var.readiness_probe,"transport",var.readiness_probe_defaults.transport)
            failure_count_threshold = lookup(var.readiness_probe,"failure_count_threshold",var.readiness_probe_defaults.failure_count_threshold)
            host                    = lookup(var.readiness_probe,"host",null)
            interval_seconds        = lookup(var.readiness_probe,"interval_seconds",var.readiness_probe_defaults.interval_seconds)
            path                    = lookup(var.readiness_probe,"path",var.readiness_probe_defaults.path)
            success_count_threshold = lookup(var.readiness_probe,"success_count_threshold",var.readiness_probe_defaults.success_count_threshold)
            timeout                 = lookup(var.readiness_probe,"timeout",var.readiness_probe_defaults.timeout)

            dynamic "header" {
              for_each = lookup(var.readiness_probe,"headers",null) != null ? var.readiness_probe.headers : {}

              content {
                name  = header.value.name
                value = header.value.value
              }
            }
          }
        }

        dynamic "startup_probe" {
          for_each = lookup(var.startup_probe,"enabled",false) == true ? [var.startup_probe] : []

          content {
            port                    = lookup(var.startup_probe,"port",var.startup_probe_defaults.port)
            transport               = lookup(var.startup_probe,"transport",var.startup_probe_defaults.transport)
            failure_count_threshold = lookup(var.startup_probe,"failure_count_threshold",var.startup_probe_defaults.failure_count_threshold)
            host                    = lookup(var.startup_probe,"host",null)
            interval_seconds        = lookup(var.startup_probe,"interval_seconds",var.startup_probe_defaults.interval_seconds)
            path                    = lookup(var.startup_probe,"path",var.startup_probe_defaults.path)
            timeout                 = lookup(var.startup_probe,"timeout",var.startup_probe_defaults.timeout)

            dynamic "header" {
              for_each = lookup(var.startup_probe,"headers",null) != null ? var.startup_probe.headers : {}

              content {
                name  = header.value.name
                value = header.value.name
              }
            }
          }
        }

  }
  }

    lifecycle {
    ignore_changes = [
      template[0].container[0].image,
      tags
    ]
  }


  dynamic "identity" {
    for_each = var.identities != null ? ["run"] : []
    content {
      type         = "UserAssigned"
      identity_ids = local.identities_full_list_ids
    }
  }

  # dynamic "identity" {
  #   for_each = var.identity_use_system_assigned == true ||  var.identities != null ? ["run"] : []
  #   content {
  #     type         = var.identity_use_system_assigned == true ? (var.identities != null ? "SystemAssigned, UserAssigned" : "SystemAssigned") : var.identities != null ? "UserAssigned" : null
  #     identity_ids = local.identities_full_list
  #   }
  # }

  dynamic "registry" {
    for_each = var.registry != null ? [var.registry] : []

    content {
      server               = var.registry.server
      identity             = try(data.azurerm_user_assigned_identity.app_id[var.registry.identity].id,null)
      password_secret_name = lookup(var.registry,"password_secret_name",null)
      username             = lookup(var.registry,"username",null)
    }
  }
}


# resource "azurerm_container_app_custom_domain" "custom_domain" {
#   count = var.appgw_hostname_override ? 0 : length(flatten([var.app_gw.hostname]))

#   name                                     = flatten([var.app_gw.hostname])[count.index]
#   container_app_id                         = azurerm_container_app.container_app.id
#   certificate_binding_type                 = "Disabled"
# }
