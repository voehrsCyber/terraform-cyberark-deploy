terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

data "template_file" "userdata_vault" {
  template = <<EOF
<powershell>
echo ${filebase64("./license.txt")} > tmp2.b64
certutil -f -decode tmp2.b64 "C:/license.xml"
& "C:/Program Files (x86)/PrivateArk/Server/CAVaultManager.exe" PostInstall /AdminPass ${var.ADMIN_PASS} /MasterPass ${var.MASTER_PASS} /RecPub "C:/recpub.key" /DRPassword Cyberark1 /LicensePath "C:/license.xml" /AcceptEULA /CloudRegion "${var.AWS_REGION}" /CloudVendor AWS
Remove-Item "C:/license.xml"
</powershell>
<persist>true</persist>
EOF
}

data "template_file" "userdata_component" {
  template = <<EOF
<powershell>
start-sleep -s 360
& "C:/Cyberark/Deployment/PVWAConfiguration.ps1" -VaultIpAddress ${aws_instance.vault-terraform.public_ip} -VaultAdminUser Administrator -VaultPort 1858 -HostName 54.93.249.64
cd "C:/Cyberark/PVWA/InstallationAutomation/Registration"
& "C:/Cyberark/PVWA/InstallationAutomation/Registration/PVWARegisterComponent.ps1" -pwd ${var.ADMIN_PASS}
start-sleep -s 360
& "C:/Cyberark/Deployment/CPMConfiguration.ps1" -VaultIpAddress ${aws_instance.vault-terraform.public_ip} -VaultAdminUser Administrator -VaultPort 1858
cd "C:/Cyberark/CPM/InstallationAutomation/Registration"
& "C:/Cyberark/CPM/InstallationAutomation/Registration/CPMRegisterCommponent.ps1" -pwd ${var.ADMIN_PASS}
</powershell>
<persist>true</persist>
EOF
depends_on = [aws_instance.vault-terraform]
}


provider "aws" {
  profile = "default"
  region  = var.AWS_REGION
}

resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "vault-terraform" {
  ami                    = var.VAULT_AMIS[var.VERSION][var.AWS_REGION]
  instance_type          = var.VAULT_INSTANCE_TYPE
  key_name               = aws_key_pair.mykey.key_name
  user_data              = data.template_file.userdata_vault.rendered
  vpc_security_group_ids = [aws_security_group.allow-all.id]
  iam_instance_profile   = aws_iam_instance_profile.kms_vault_terraform_profile.name
  tags = {
    Name = var.VAULT_INSTANCE_NAME
  }
}

resource "aws_instance" "components-terraform" {
  ami                    = var.COMPONENTS_AMIS[var.VERSION][var.AWS_REGION]
  instance_type          = var.COMPONENTS_INSTANCE_TYPE
  key_name               = aws_key_pair.mykey.key_name
  user_data              = data.template_file.userdata_component.rendered
  depends_on             = [aws_instance.vault-terraform]
  vpc_security_group_ids = [aws_security_group.allow-all.id]
  tags = {
    Name = var.COMPONENTS_INSTANCE_NAME
  }
}

