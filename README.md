# azure-container-app

Sample input:

```
project = "project1"

systemenv = "stage"



resource_group_name = "1555-Tests"

location = "West Europe"

vnet = 

container_app_envs = {
    env1 = {
        subnet_id = "10.64.0.0/18"
        resource_group = "rg1"
        region = "west europe"
    }
}

container_apps = {
    app1 = {
        name = "app1"
        env  = "env1" 
        image = "nginx"
        tag = "latest"
        volume_mounts = ""
        ingress_enabled = true
        ingress = {}
        secrets = [managed,config]

    }
}
```

Secrets:
```
secrets = {
    managed = {
        key_vault_name = "key vault name/id in Azure"
        import_all = true/false. If true, loop trough all secrets and create env vars with the secret name.
        secrets = {
            key_internal_only = {
                secret_name = "the name of the secret in the vault"
                secret_envvar = "the name of the variable". If this is missing , use secret_name. 
            }            
        }
    }
    config = {
        key_vault_name = "key vault name/id in Azure"
        import_all = true/false. If true, loop trough all secrets and create env vars with the secret name.
    }
}

```

Vault:
  dev:
    PRIMARY_DB_HOST: myhost
    DB_DATABASE: mydb
    DB_PASSWORD: mypass
    READ_DB_HOST: myreadhost
-->
```
secrets = {
    managed_primary = {
        key_vault_name = "dev"
        import_all = true
        secrets = {
            dbhost = {
                secret_name = "PRIMARY_DB_HOST"
                secret_envvar = "DB_HOST". 
            }            
        }
    }
    managed_app2 = {
        key_vault_name = "dev"
        import_all = true
        secrets = {
            dbhost = {
                secret_name = "PRIMARY_DB_HOST"
                secret_envvar = "ANOTHER_DB_HOST_VARNAME". 
            }            
        }
    }    
    managed_readonly = {
        key_vault_name = "dev"
        import_all = true
        secrets = {
            dbhost = {
                secret_name = "READ_DB_HOST"
                secret_envvar = "DB_HOST". 
            }            
        }
    }
}

container_apps = {
    writeapp = {
        secrets = [managed_primary,config]

    }
    readapp = {
        secrets = [managed_readonly,config]

    }
}

```

















