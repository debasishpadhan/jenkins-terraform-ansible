# Create ssh-key

resource "aws_key_pair" "key-tf" {
  key_name   = "deployer-key"
  public_key = file("${path.module}/id_rsa.pub")
}