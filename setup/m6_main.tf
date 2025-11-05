ephemeral "random_password" "app_password" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret" "app_password" {
  name_prefix = format("%s-app-password-", local.name_prefix)

  tags = local.common_tags

}

resource "aws_secretsmanager_secret_version" "app_password_version" {
  secret_id                = aws_secretsmanager_secret.app_password.id
  secret_string_wo         = "" # to be replaced
  secret_string_wo_version = "" # to be replaced

}