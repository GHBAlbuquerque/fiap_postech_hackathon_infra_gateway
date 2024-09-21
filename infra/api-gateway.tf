locals {
  load_balancer_dns    = var.application_load_balancer_dns
  lambda_authorize_uri = "arn:aws:apigateway:${var.region}:lambda:path/2024-04-22/functions/${var.lambda_arn}/invocations"
}

resource "aws_api_gateway_rest_api" "api_gateway_fiap_postech" {
  name        = "api_gateway_fiap_postech"
  description = "API Rest para agendamento de consultas médicas executada no Hackathon da FIAP PosTech Arquitetura de Sistemas"

  body = jsonencode(
    {
      "openapi" : "3.0.1",
      "info" : {
        "title" : "Hackathon FIAP PosTech",
        "description" : "API Rest para agendamento de consultas médicas executada no Hackathon da FIAP PosTech Arquitetura de Sistemas",
        "version" : "v1"
      },
      "servers" : [
        {
          "url" : "http://${local.load_balancer_dns}",
          "description" : "Generated server url"
        }
      ],
      "paths" : {
        "/" : {
          "get" : {
            "operationId" : "Get",
            "responses" : {
              "200" : {
                "description" : "200 response",
                "headers" : {
                  "Access-Control-Allow-Origin" : {
                    "schema" : {
                      "type" : "string"
                    }
                  }
                },
                "content" : {}
              }
            },
            "x-amazon-apigateway-integration" : {
              "httpMethod" : "GET",
              "uri" : "http://${local.load_balancer_dns}/",
              "responses" : {
                "default" : {
                  "statusCode" : "200",
                  "responseParameters" : {
                    "method.response.header.Access-Control-Allow-Origin" : "'*'"
                  }
                }
              },
              "passthroughBehavior" : "when_no_match",
              "type" : "http"
            }
          },
          "options" : {
            "responses" : {
              "200" : {
                "description" : "200 response",
                "headers" : {
                  "Access-Control-Allow-Origin" : {
                    "schema" : {
                      "type" : "string"
                    }
                  },
                  "Access-Control-Allow-Methods" : {
                    "schema" : {
                      "type" : "string"
                    }
                  },
                  "Access-Control-Allow-Headers" : {
                    "schema" : {
                      "type" : "string"
                    }
                  }
                },
                "content" : {
                  "application/json" : {
                    "schema" : {
                      "$ref" : "#/components/schemas/Empty"
                    }
                  }
                }
              }
            },
            "x-amazon-apigateway-integration" : {
              "responses" : {
                "default" : {
                  "statusCode" : "200",
                  "responseParameters" : {
                    "method.response.header.Access-Control-Allow-Methods" : "'GET,OPTIONS'",
                    "method.response.header.Access-Control-Allow-Headers" : "'Content-Type,X-Amz-Date,Authorization,X-Api-Key'",
                    "method.response.header.Access-Control-Allow-Origin" : "'*'"
                  }
                }
              },
              "requestTemplates" : {
                "application/json" : "{\"statusCode\": 200}"
              },
              "passthroughBehavior" : "when_no_match",
              "type" : "mock"
            }
          }
        },
        "/actuator/health" : {
          "get" : {
            "operationId" : "Actuator",
            "responses" : {
              "200" : {
                "description" : "200 response",
                "headers" : {
                  "Access-Control-Allow-Origin" : {
                    "schema" : {
                      "type" : "string"
                    }
                  }
                },
                "content" : {}
              }
            },
            "x-amazon-apigateway-integration" : {
              "httpMethod" : "GET",
              "uri" : "http://${local.load_balancer_dns}/actuator/health",
              "responses" : {
                "default" : {
                  "statusCode" : "200",
                  "responseParameters" : {
                    "method.response.header.Access-Control-Allow-Origin" : "'*'"
                  }
                }
              },
              "passthroughBehavior" : "when_no_match",
              "type" : "http"
            }
          }
        }
      },
      "components" : {
        "schemas" : {
          "CustomError" : {
            "type" : "object",
            "properties" : {
              "message" : {
                "type" : "string"
              },
              "field" : {
                "type" : "string"
              },
              "attemptedValue" : {
                "type" : "object"
              }
            }
          },
          "ExceptionDetails" : {
            "type" : "object",
            "properties" : {
              "type" : {
                "type" : "string"
              },
              "title" : {
                "type" : "string"
              },
              "code" : {
                "type" : "string"
              },
              "detail" : {
                "type" : "string"
              },
              "status" : {
                "type" : "integer",
                "format" : "int32"
              },
              "date" : {
                "type" : "string",
                "format" : "date-time"
              },
              "errors" : {
                "type" : "array",
                "items" : {
                  "$ref" : "#/components/schemas/CustomError"
                }
              }
            }
          }
        },
        "securitySchemes" : {
          "lambda_authorizer" : {
            "type" : "apiKey",
            "name" : "auth",
            "in" : "header",
            "x-amazon-apigateway-authtype" : "custom",
            "x-amazon-apigateway-authorizer" : {
              "type" : "request",
              "identitySource" : "method.request.header.email_usuario, method.request.header.senha_usuario",
              "authorizerCredentials" : var.lab_role_arn,
              "authorizerUri" : local.lambda_authorize_uri,
              "authorizerResultTtlInSeconds" : 0
            }
          }
        }
      }
    }
  )

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "postech_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway_fiap_postech.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api_gateway_fiap_postech.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "postech_stage" {
  deployment_id = aws_api_gateway_deployment.postech_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_fiap_postech.id
  stage_name    = "postech_stage"
}

output "api_gateway_id" {
  value = aws_api_gateway_rest_api.api_gateway_fiap_postech.id
}

