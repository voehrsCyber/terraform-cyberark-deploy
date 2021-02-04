terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}
resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

data "template_file" "userdata_win" {
  template = <<EOF
<script>
echo "" > _INIT_STARTED_
net user var.INSTANCE_USERNAME /add /y
net user var.INSTANCE_USERNAME var.INSTANCE_PASSWORD
net localgroup administrators var.INSTANCE_USERNAME /add
echo "" > _INIT_COMPLETE_
</script>
<persist>false</persist>
EOF
}

resource "aws_instance" "jpv-vault-12-terraform" {
  ami                    = "ami-04ac45703e289ef12"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.mykey.key_name
  user_data              = data.template_file.userdata_win.rendered
  vpc_security_group_ids = [aws_security_group.allow-all.id]
  tags = {
    Name = "jpv-vault-12-terraform"
  }
}
