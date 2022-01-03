data "aws_ami" "amis" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu*"]
  }
}

resource "aws_instance" "instance" {

  ami           = data.aws_ami.amis.id
  for_each      = var.instances
  instance_type = each.value.instance_type
  #tags          = each.value
  tags = {
    name = lookup(var.instance_tags, "web_server")
  }
  key_name = aws_key_pair.ssh_key.key_name
  network_interface {
    network_interface_id = aws_network_interface.subnet_association.id
    device_index         = 0
  }
  user_data = templatefile("user_data.tftpl", {})
}

resource "aws_eip" "lb" {
  for_each = var.instances
  instance = aws_instance.instance[each.key].id
  vpc      = true
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("ssh_key.pub")
}
