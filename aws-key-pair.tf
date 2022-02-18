# Create ssh-key

resource "aws_key_pair" "key-tf" {
  key_name   = "deployer-key"
  public_key = file("/var/lib/jenkins/id_rsa_key/id_rsa.pub")
}
