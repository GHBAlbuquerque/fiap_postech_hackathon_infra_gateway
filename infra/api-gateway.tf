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
        },
        "/users" : {
          "get" : {
            "tags" : [
              "user-controller"
            ],
            "operationId" : "getuserByCpf",
            "parameters" : [
              {
                "name" : "cpf",
                "in" : "query",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "email_usuario",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "senha_usuario",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              }
            ],
            "responses" : {
              "400" : {
                "description" : "Bad Request",
                "content" : {
                  "application/json" : {
                    "schema" : {
                      "$ref" : "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "403" : {
                "description" : "Forbidden",
                "content" : {
                  "application/json" : {
                    "schema" : {
                      "$ref" : "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "404" : {
                "description" : "Not Found",
                "content" : {
                  "application/json" : {
                    "schema" : {
                      "$ref" : "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "500" : {
                "description" : "Internal Server Error",
                "content" : {
                  "application/json" : {
                    "schema" : {
                      "$ref" : "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "200" : {
                "description" : "Success",
                "content" : {
                  "application/json" : {
                    "schema" : {
                      "$ref" : "#/components/schemas/GetClientResponse"
                    }
                  }
                }
              }
            },
            "security" : [{ "lambda_authorizer" : [] }],
            "x-amazon-apigateway-integration" : {
              "httpMethod" : "GET",
              "payloadFormatVersion" : "1.0",
              "requestParameters" : {
                "integration.request.header.microsservice" : "'ms_usuario'"
              },
              "type" : "HTTP_PROXY",
              "uri" : "http://${local.load_balancer_dns}/users"
            }
          },
          "post" : {
            "tags" : [
              "user-controller"
            ],
            "operationId" : "registeruser",
            "requestBody" : {
              "content" : {
                "application/json" : {
                  "schema" : {
                    "$ref" : "#/components/schemas/RegisteruserRequest"
                  }
                }
              },
              "required" : true
            },
            "parameters" : [
              {
                "name" : "email_usuario",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "senha_usuario",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              }
            ],
            "responses" : {
              "400" : {
                "description" : "Bad Request",
                "content" : {
                  "application/json" : {
                    "schema" : {
                      "$ref" : "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "403" : {
                "description" : "Forbidden",
                "content" : {
                  "application/json" : {
                    "schema" : {
                      "$ref" : "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "404" : {
                "description" : "Not Found",
                "content" : {
                  "application/json" : {
                    "schema" : {
                      "$ref" : "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "500" : {
                "description" : "Internal Server Error",
                "content" : {
                  "application/json" : {
                    "schema" : {
                      "$ref" : "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "200" : {
                "description" : "Success",
                "content" : {
                  "application/json" : {
                    "schema" : {
                      "$ref" : "#/components/schemas/RegisteruserResponse"
                    }
                  }
                }
              }
            },
            "x-amazon-apigateway-integration" : {
              "httpMethod" : "POST",
              "payloadFormatVersion" : "1.0",
              "requestParameters" : {
                "integration.request.header.microsservice" : "'ms_usuario'"
              },
              "type" : "HTTP_PROXY",
              "uri" : "http://${local.load_balancer_dns}/users"
            }
          }
        },
        "/users/{id}" : {
          "delete" : {
            "tags" : [
              "user-controller"
            ],
            "operationId" : "deactivateuser",
            "parameters" : [
              {
                "name" : "id",
                "in" : "path",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "email_usuario",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "senha_usuario",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              }
            ],
            "responses" : {
              "400" : {
                "description" : "Bad Request",
                "content" : {
                  "application/json" : {
                    "schema" : {
                      "$ref" : "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "403" : {
                "description" : "Forbidden",
                "content" : {
                  "application/json" : {
                    "schema" : {
                      "$ref" : "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "404" : {
                "description" : "Not Found",
                "content" : {
                  "application/json" : {
                    "schema" : {
                      "$ref" : "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "500" : {
                "description" : "Internal Server Error",
                "content" : {
                  "application/json" : {
                    "schema" : {
                      "$ref" : "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "200" : {
                "description" : "Success"
              },
              "default" : {
                "headers" : {},
                "content" : {},
                "description" : ""
              }
            },
            "security" : [{ "lambda_authorizer" : [] }],
            "x-amazon-apigateway-integration" : {
              "httpMethod" : "DELETE",
              "payloadFormatVersion" : "1.0",
              "requestParameters" : {
                "integration.request.header.microsservice" : "'ms_usuario'",
                "integration.request.header.email_usuario" : "method.request.header.email_usuario",
                "integration.request.header.senha_usuario" : "method.request.header.senha_usuario",
                "integration.request.path.id" : "method.request.path.id"
              },
              "type" : "HTTP_PROXY",
              "uri" : "http://${local.load_balancer_dns}/users/{id}"
            }
          }
        }
        "/users/confirmation" : {
          "post" : {
            "tags" : ["user-controller"], "operationId" : "confirmSignUp",
            "requestBody" : {
              "content" : {
                "application/json" : { "schema" : { "$ref" : "#/components/schemas/ConfirmSignUpRequest" } }
              }, "required" : true
            },
            "parameters" : [
              {
                "name" : "email_usuario",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "senha_usuario",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              }
            ],
            "responses" : {
              "400" : {
                "description" : "Bad Request",
                "content" : { "application/json" : { "schema" : { "$ref" : "#/components/schemas/ExceptionDetails" } } }
              }, "404" : {
                "description" : "Not Found",
                "content" : { "application/json" : { "schema" : { "$ref" : "#/components/schemas/ExceptionDetails" } } }
              }, "500" : {
                "description" : "Internal Server Error",
                "content" : { "application/json" : { "schema" : { "$ref" : "#/components/schemas/ExceptionDetails" } } }
              }, "200" : {
                "description" : "Success", "content" : { "application/json" : { "schema" : { "type" : "boolean" } } }
              }
            },
            "x-amazon-apigateway-integration" : {
              "httpMethod" : "POST",
              "payloadFormatVersion" : "1.0",
              "requestParameters" : {
                "integration.request.header.microsservice" : "'ms_usuario'"
              },
              "type" : "HTTP_PROXY",
              "uri" : "http://${local.load_balancer_dns}/users/confirmation"
            }
          }
        },
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
                  "$ref" : "#/components/schemas/userror"
                }
              }
            }
          },
          "RegisteruserRequest" : {
            "type" : "object",
            "properties" : {
              "name" : {
                "type" : "string"
              },
              "birthday" : {
                "type" : "string",
                "format" : "date"
              },
              "cpf" : {
                "type" : "string"
              },
              "email" : {
                "type" : "string"
              }
            }
          },
          "RegisteruserResponse" : {
            "type" : "object",
            "properties" : {
              "id" : {
                "type" : "string"
              }
            }
          },
          "ConfirmSignUpRequest" : {
            "required" : ["code", "cpf"],
            "type" : "object",
            "properties" : { "cpf" : { "type" : "string" }, "code" : { "type" : "string" } }
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

