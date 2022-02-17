# Create instance

resource "aws_instance" "web" {
  # count                  = 2
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key-tf.key_name
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  tags                   = { Name = "Terra_Ansi_Instance" }
  # user_data              = file("${path.module}/script.sh")

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
    command = "ansible-playbook  -i ${aws_instance.web.public_ip}, --private-key ${path.module}/id_rsa docker.yaml"
  }
  provisioner "remote-exec" {
    script = "./script.sh"
  }
  # provisioner "file" {
  #   source      = "readme.md"
  #   destination = "/tmp/readme.md"
  # }
  # provisioner "file" {
  #   content     = "This is a test content message"
  #   destination = "/tmp/content.md"
  # }
  # provisioner "local-exec" {
  #   working_dir = "/tmp"
  #   command     = "echo ${self.public_ip} >> mypublicip.txt"
  # }
  # provisioner "local-exec" {
  #   working_dir = "/etc/ansible"
  #   command     = "sudo sed -i s/PUBLICHOSTIP/${self.public_ip}/ hosts"
  # }
  # provisioner "local-exec" {
  #   working_dir = "/etc/ansible"
  #   command     = "bash "
  # }
  # provisioner "local-exec" {
  #   interpreter = ["/usr/bin/python3", "-c"]
  #   command     = "print('HelloWorld!')"
  # }
  # provisioner "local-exec" {
  #   on_failure = continue
  #   command = "env>env.txt"
  #   environment = {
  #     envname = "env_value"
  #   }
  # }
  # provisioner "local-exec" {
  #   command = "echo 'CREATED'"
  # }
  # provisioner "local-exec" {
  #   when    = destroy
  #   command = "echo 'DESTROYED'"
  # }
  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo apt install net-tools -y",
  #     "ifconfig > /tmp/ifconfig.output",
  #     "echo 'Hello Debasish' > /tmp/output.txt"
  #   ]
  # }
  # provisioner "remote-exec" {
  #   script = "./localscript.sh"
  # }
}

output "aws_ec2_public_ip" {
  value = aws_instance.web.public_ip
}