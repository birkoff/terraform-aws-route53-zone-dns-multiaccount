```hcl
locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
  env = local.env_vars.locals.env
  region = local.env_vars.locals.region
  application = local.env_vars.locals.application
  service = local.env_vars.locals.service
  component = "route53-zones"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "aws" {
      alias  = "dns"
      region = "${local.env_vars.locals.region}"
      allowed_account_ids = [
        "${local.env_vars.locals.account_mapping["dns"]}"
      ]
      assume_role {
        role_arn = "arn:aws:iam::${local.env_vars.locals.account_mapping["dns"]}:role/${local.env_vars.locals.account_role_name}"
      }
    }
    provider "aws" {
      region = "${local.env_vars.locals.region}"
      allowed_account_ids = [
        "${local.env_vars.locals.account_mapping[local.env]}"
      ]
      assume_role {
        role_arn = "arn:aws:iam::${local.env_vars.locals.account_mapping[local.env]}:role/${local.env_vars.locals.account_role_name}"
      }
      default_tags {
        tags = {
          Environment = "${local.env}"
          ManagedBy   = "terraform"
          DeployedBy  = "terragrunt"
          Creator     = "${get_env("USER", "NOT_SET")}"
          Application = "${local.application}"
          Service = "${local.service}"
          Component   = "${local.component}"
        }
      }
    }
EOF
}

terraform {
  source = "birkoff/route53-zone-dns-multiaccount/aws"
}

inputs = {
  env                           = local.env
  application                   = local.env_vars.locals.application
  service                       = local.env_vars.locals.service
  main_hosted_zone_name         = local.env_vars.locals.main_public_dns_zone_name
  hosted_zone_name              = "hosted-zone-name.mydomain.com"
  ns_record_subdomain           = "hosted-zone-name"
  subject_alternative_names = [
    "hosted-zone-name.mydomain.com",
    "*.hosted-zone-name.mydomain.com"
  ]
}

```