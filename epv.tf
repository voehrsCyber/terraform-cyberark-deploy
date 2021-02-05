terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

data "template_file" "userdata_win" {
  template = <<EOF
<powershell>
net user ${var.INSTANCE_USERNAME} '${var.INSTANCE_PASSWORD}' /add /y
net localgroup administrators ${var.INSTANCE_USERNAME} /add
echo ${filebase64("./license.txt")} > tmp2.b64
certutil -f -decode tmp2.b64 "C:/Program Files (x86)/PrivateArk/Server/Conf/License.xml"
</powershell>
EOF
}
provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}
resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "jpv-vault-12-terraform" {
  ami                    = "ami-04ac45703e289ef12"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.mykey.key_name
  user_data = data.template_file.userdata_win.rendered
  vpc_security_group_ids = [aws_security_group.allow-all.id]
  tags = {
    Name = "jpv-vault-12-terraform"
  }
}
