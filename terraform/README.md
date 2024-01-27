## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.7.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_init"></a> [init](#module\_init) | ./modules/init | n/a |
| <a name="module_kubevirt"></a> [kubevirt](#module\_kubevirt) | ./modules/kubevirt | n/a |
| <a name="module_notify"></a> [notify](#module\_notify) | ./modules/notify | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_key"></a> [access\_key](#input\_access\_key) | Access key to AWS console | `string` | `"XXXXXXXXXXXXXX"` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | The AMI to use | `string` | `"ami-0e3f46af8e849a537"` | no |
| <a name="input_ami_key_pair_name"></a> [ami\_key\_pair\_name](#input\_ami\_key\_pair\_name) | n/a | `string` | `"/home/victor/.ssh/my_aws.pub"` | no |
| <a name="input_aws_instance_ssh_key"></a> [aws\_instance\_ssh\_key](#input\_aws\_instance\_ssh\_key) | n/a | `string` | `"/home/victor/.ssh/my_aws"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `"t2.medium"` | no |
| <a name="input_number_of_worker"></a> [number\_of\_worker](#input\_number\_of\_worker) | number of worker instances to be join on cluster. | `number` | `1` | no |
| <a name="input_region"></a> [region](#input\_region) | The region zone on AWS | `string` | `"eu-west-1"` | no |
| <a name="input_secret_key"></a> [secret\_key](#input\_secret\_key) | Secret key to AWS console | `string` | `"YYYYYYYYYY"` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Volume size of instance | `string` | `"60"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_master_public_ip"></a> [instance\_master\_public\_ip](#output\_instance\_master\_public\_ip) | Print something |
| <a name="output_instance_workers_public_ip"></a> [instance\_workers\_public\_ip](#output\_instance\_workers\_public\_ip) | n/a |