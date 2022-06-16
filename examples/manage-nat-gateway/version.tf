terraform {
  required_version = ">=1.0.9"
  experiments = [ module_variable_optional_attrs ]
  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">=1.60.22"
    }
  }
}
