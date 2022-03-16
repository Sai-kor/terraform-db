module "rabbitmq" {
  source = "./module/common-db-ec2"
  username = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["username"]
  password =jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["password"]
  ENV = var.ENV
  AMI = data.aws_ami.ami.id
  INSTANCE_TYPE = var.RABBITMQ_INSTANCE_TYPE
  SUBNET_ID = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS[0]
  VPC_ID = data.terraform_remote_state.vpc.outputs.VPC_ID
  PRIVATE_CIDR = data.terraform_remote_state.vpc.outputs.PRIVATE_CIDR
  ALL_SUBNET_CIDR = concat(data.terraform_remote_state.vpc.outputs.PRIVATE_CIDR,tolist([data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]))
  DB_COMPONENT = "rabbitmq"
  DB_PORT = 5672
  PRIVATE_HOSTED_ZONE_ID = data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ZONE_ID
}





