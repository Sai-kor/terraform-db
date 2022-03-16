resource "aws_db_instance" "mysql" {
  identifier =  "mysql-${var.ENV}"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "sample-mysql"
  username             = jsondecode(data.aws_secretsmanager_secret_version.dev-secrets.secret_string)["RDS_MYSQL_USER"]
  password             = jsondecode(data.aws_secretsmanager_secret_version.dev-secrets.secret_string)["RDS_MYSQL_PASS"]
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.mysql-db-subnet.name
  vpc_security_group_ids = [aws_security_group.mysql.id]
}

resource "aws_db_subnet_group" "mysql-db-subnet" {
  name       = "mysql-${var.ENV}"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS

  tags = {
    Name = "mysql-${var.ENV}"
  }
}

resource "aws_security_group" "mysql" {
  name        = "sg_mysql-${var.ENV}"
  description = "sg_mysql-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description      = "APP"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = concat(data.terraform_remote_state.vpc.outputs.PRIVATE_CIDR,tolist([data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]))
            // only for connection purpose we are giving permission for other default vpc (to load schema) in this lab purpose ,otherwise we shouldn't do this in org.
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg_mysql-${var.ENV}"
  }
}