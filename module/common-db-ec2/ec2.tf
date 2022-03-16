resource "aws_spot_instance_request" "db" {
  ami           = var.AMI
  instance_type = var.INSTANCE_TYPE
  tags = {
    Name = "${var.DB_COMPONENT}-${var.ENV}"
  }
  subnet_id = var.SUBNET_ID
  #creates ec2 spot instance in that particular vpc and private subnet id getting data from data.tf remote state resource
  wait_for_fulfillment = true
  vpc_security_group_ids = [aws_security_group.sg.id]
}

resource "aws_ec2_tag" "spot-instances" {
  count = length(aws_spot_instance_request.db)
  resource_id = aws_spot_instance_request.db.spot_instance_id[count.index]
  key         = "Name"
  value       = "${var.DB_COMPONENT}-${var.ENV}"
}
