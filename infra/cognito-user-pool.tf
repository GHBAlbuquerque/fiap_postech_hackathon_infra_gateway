resource "aws_cognito_user_pool" "user_group_postech_fiap" {
  name = "user_group_postech_fiap"

  auto_verified_attributes = ["email"]

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  password_policy {
    temporary_password_validity_days = 7
    minimum_length                   = 6
    require_uppercase                = false
    require_symbols                  = false
    require_numbers                  = false
  }


}

resource "aws_cognito_user_pool_client" "client" {
  name = "client_fiap_pos_tech"

  user_pool_id = aws_cognito_user_pool.user_group_postech_fiap.id

  generate_secret     = false
  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
}

resource "aws_cognito_user" "first_user" {
  user_pool_id = aws_cognito_user_pool.user_group_postech_fiap.id
  username     = "aneleh.annavoig@gmail.com"
  password     = "FIAPauth123_"

  attributes = {
    email          = "aneleh.annavoig@gmail.com"
    email_verified = true
  }
}