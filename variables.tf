# General
variable "location" {}
variable "resource_group" {}


variable "tags" { default = null }



# Container app object

variable "app_name" {}
variable "app_image" {}
variable "app_command" { default = null }
variable "app_volumes" { default = null }
variable "app_secrets" { default = null }
variable "secrets" { default = null }
# variable "identity_default" { default = null }
variable "app_ingress_enabled" { default = true }

variable "appgw_hostname_override" { default = false }




variable "app_gw" {  default = null  }
variable "workload_profile" {}
variable "container_app_environment_id" {}

variable "cpu" { default = 0.25 }
variable "memory" { default = "0.5Gi" }
variable "max_replicas" { default = 1 }
variable "min_replicas" { default = 1 }


variable "app_env" {
  type = map(string)
  default = {}
}

variable "identities" { default = [] }
variable "identity_use_system_assigned" { default = false }


variable "target_port" { default = 80 }
variable "registry" { default = null }




# Config Defaults
variable "revision_mode" { default = "Single" }


# Probes
variable "liveness_probe" { default = {} }
variable "liveness_probe_defaults" {
                      default = {
                          port = 80
                          transport = "HTTP"
                          failure_count_threshold = 3
                          initial_delay = 60
                          interval_seconds = 30
                          path = "/"
                          timeout = 20
                      } 
                          }

variable "readiness_probe" { default = {} }
variable "readiness_probe_defaults" {
                      default = {
                          port = 80
                          transport = "HTTP"
                          failure_count_threshold = 3
                          initial_delay = 60
                          interval_seconds = 30
                          path = "/"
                          timeout = 20
                          success_count_threshold = 3
                      } 
                          }

variable "startup_probe" { default = {} }
variable "startup_probe_defaults" {
                      default = {
                          port = 80
                          transport = "HTTP"
                          failure_count_threshold = 3
                          initial_delay = 60
                          interval_seconds = 30
                          path = "/"
                          timeout = 20
                      } 
                          }




variable "location" {}
variable "replica_timeout_in_seconds" { default = 1000 }

variable "manual_trigger_config_parallelism" { default = 1 }
variable "replica_completion_count" { default = 1 }