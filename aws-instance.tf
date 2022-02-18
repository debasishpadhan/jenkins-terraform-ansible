# Create instance

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key-tf.key_name
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  tags                   = { Name = "Terra_Ansi_Instance" }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/id_rsa")
    host        = aws_instance.web.public_ip
  }
  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.web.public_ip}, --private-key /var/lib/jenkins/id_rsa_key/id_rsa docker.yaml"
  }
  provisioner "remote-exec" {
    script = "./script.sh"
  }
}

output "aws_ec2_public_ip" {
  value = aws_instance.web.public_ip
}
