# VPC Module Example

This module will create new Subnet and Route rules with exists VPC.

## Usage

To run this example, you need first replace the configuration like `vpc_id`, `subnet_name` etc, and then execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note, this example may create resources which cost money. Run `terraform destroy` if you don't need these resources.

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The id of vpc. |
| subnet_id | The id of subnet. |
| route_table_id | The id of route table. |
| route_entry_id | The id of route table entry. |
