/*resource "aws_api_gateway_authorizer" "lambda_authorizer_cpf" {
  name                   = "lambda_authorizer_cpf"
  rest_api_id            = aws_api_gateway_rest_api.api_gateway_fiap_postech.id
  authorizer_uri         = "arn:aws:apigateway:${var.region}:lambda:path/2024-04-22/functions/${var.lambda_arn}/invocations"
  authorizer_credentials = var.lab_role_arn
  type                   = "REQUEST"
  identity_source        = "method.request.header.cpf_cliente"
}*/ # FIXME: foi criada direto no json open api em securitySchemes e associada. não funcionou subindo via terraform direto (auth: NONE) e nao deixou colocar depends on por circular ref


resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.api_gateway_fiap_postech.execution_arn}/*/*"
}