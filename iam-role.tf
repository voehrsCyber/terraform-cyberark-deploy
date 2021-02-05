resource "aws_iam_role" "kms_vault_terraform_role" {
  name = "kms_vault_terraform_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "kms_vault_terraform_profile" {
  name = "kms_vault_terraform_profile"
  role = aws_iam_role.kms_vault_terraform_role.name
}

resource "aws_iam_role_policy" "kms_vault_terraform_policy" {
  name = "kms_vault_terraform_policy"
  role = aws_iam_role.kms_vault_terraform_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["kms:CreateKey", "kms:GenerateRandom", "kms:TagResource", "kms:Encrypt", "kms:Decrypt", "kms:EnableKeyRotation", "kms:UpdateKeyDescription", "kms:CreateAlias" ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

