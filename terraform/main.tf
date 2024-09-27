provider "aws" {
  region = "us-east-1"  # Altere para a região desejada
}

resource "aws_cognito_user_pool" "techchallenge-userspool" {
  name = "techchallenge-userspool"

  # Configuração da política de senha
  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  alias_attributes         = ["email", "preferred_username"]
  
  # Configuração dos tipos de autenticação permitidos
  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  auto_verified_attributes = ["email"]

  # Adicionando o atributo customizado CPF
  schema {
    attribute_data_type      = "String"
    name                     = "custom:cpf"
    required                 = false
    mutable                  = true
    string_attribute_constraints {
      min_length = 11
      max_length = 11
    }
  }

  # Adicionando o atributo username
  schema {
    attribute_data_type      = "String"
    name                     = "username"
    required                 = false
    mutable                  = false
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }
}

resource "aws_cognito_user_pool_client" "techchallenge-usersclient" {
  name         = "techchallenge-usersclient"
  user_pool_id = aws_cognito_user_pool.techchallenge-userspool.id

  explicit_auth_flows = [
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
}