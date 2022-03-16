
## this null resource do nothing , but we give provisioner , provisioner is one which is going to help you to connect to ec2 instances/linux instances by providing required information.It can connect to the instances and execute the commands

resource "null_resource" "db-deploy" {
  triggers = {
    instance_ids = join(",",aws_spot_instance_request.db.spot_instance_id)
    //expects string so here list to string terraform so using join.
  }
  connection {
    type     = "ssh"
    user     = local.username
    password = local.password
    host     = aws_spot_instance_request.db.*.private_ip
  }
  provisioner "remote-exec" {
    inline = [
      "ansible-pull -U https://github.com/Sai-kor/ansible.git roboshop-pull.yml -e COMPONENT=mongodb -e ENV=${var.ENV}"
    ]
  }
}

locals {
  username = var.username
  password = var.password
}