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
        "/swagger-ui/index" : {
          "get" : {
            "operationId" : "Swagger",
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
              "uri" : "http://${local.load_balancer_dns}/swagger-ui/index.html",
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
        "/products/{id}" : {
          "get" : {
            "tags" : [
              "product-controller"
            ],
            "operationId" : "findProductByIdAndName",
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
                "name" : "type",
                "in" : "query",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "cpf_cliente",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "senha_cliente",
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
                      "$ref" : "#/components/schemas/FullProductResponse"
                    }
                  }
                }
              }
            },
            "security" : [{ "lambda_authorizer_cpf" : [] }],
            "x-amazon-apigateway-integration" : {
              "httpMethod" : "GET",
              "requestParameters" : {
                "integration.request.header.microsservice" : "'ms_produto'",
                "integration.request.path.id" : "method.request.path.id"
              },
              "payloadFormatVersion" : "1.0",
              "type" : "HTTP_PROXY",
              "uri" : "http://${local.load_balancer_dns}/products/{id}"
            }
          },
          "put" : {
            "tags" : [
              "product-controller"
            ],
            "operationId" : "updateProduct",
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
                "name" : "cpf_cliente",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "senha_cliente",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              }
            ],
            "requestBody" : {
              "content" : {
                "application/json" : {
                  "schema" : {
                    "$ref" : "#/components/schemas/UpdateProductRequest"
                  }
                }
              },
              "required" : true
            },
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
                      "$ref" : "#/components/schemas/FullProductResponse"
                    }
                  }
                }
              }
            },
            "security" : [{ "lambda_authorizer_cpf" : [] }],
            "x-amazon-apigateway-integration" : {
              "httpMethod" : "PUT",
              "payloadFormatVersion" : "1.0",
              "requestParameters" : {
                "integration.request.header.microsservice" : "'ms_produto'",
                "integration.request.path.id" : "method.request.path.id"
              },
              "type" : "HTTP_PROXY",
              "uri" : "http://${local.load_balancer_dns}/products/{id}"
            }
          },
          "delete" : {
            "tags" : [
              "product-controller"
            ],
            "operationId" : "deleteProduct",
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
                "name" : "cpf_cliente",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "senha_cliente",
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
              }
            },
            "security" : [{ "lambda_authorizer_cpf" : [] }],
            "x-amazon-apigateway-integration" : {
              "httpMethod" : "DELETE",
              "payloadFormatVersion" : "1.0",
              "requestParameters" : {
                "integration.request.header.microsservice" : "'ms_produto'",
                "integration.request.path.id" : "method.request.path.id"
              },
              "type" : "HTTP_PROXY",
              "uri" : "http://${local.load_balancer_dns}/products/{id}"
            }
          }
        },
        "/products" : {
          "get" : {
            "tags" : [
              "product-controller"
            ],
            "operationId" : "findProducts",
            "parameters" : [
              {
                "name" : "type",
                "in" : "query",
                "required" : false,
                "schema" : {
                  "type" : "string",
                  "enum" : [
                    "SANDWICH",
                    "SIDE_DISH",
                    "DRINK"
                  ]
                }
              },
              {
                "name" : "cpf_cliente",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "senha_cliente",
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
                      "type" : "array",
                      "items" : {
                        "$ref" : "#/components/schemas/FullProductResponse"
                      }
                    }
                  }
                }
              }
            },
            "security" : [{ "lambda_authorizer_cpf" : [] }],
            "x-amazon-apigateway-integration" : {
              "httpMethod" : "GET",
              "payloadFormatVersion" : "1.0",
              "requestParameters" : {
                "integration.request.header.microsservice" : "'ms_produto'"
              },
              "type" : "HTTP_PROXY",
              "uri" : "http://${local.load_balancer_dns}/products"
            }
          },
          "post" : {
            "tags" : [
              "product-controller"
            ],
            "operationId" : "createProduct",
            "requestBody" : {
              "content" : {
                "application/json" : {
                  "schema" : {
                    "$ref" : "#/components/schemas/CreateProductRequest"
                  }
                }
              },
              "required" : true
            },
            "parameters" : [
              {
                "name" : "cpf_cliente",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "senha_cliente",
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
                      "$ref" : "#/components/schemas/FullProductResponse"
                    }
                  }
                }
              }
            },
            "security" : [{ "lambda_authorizer_cpf" : [] }],
            "x-amazon-apigateway-integration" : {
              "httpMethod" : "POST",
              "payloadFormatVersion" : "1.0",
              "requestParameters" : {
                "integration.request.header.microsservice" : "'ms_produto'"
              },
              "type" : "HTTP_PROXY",
              "uri" : "http://${local.load_balancer_dns}/products"
            }
          }
        },
        "/orders" : {
          "get" : {
            "tags" : [
              "order-controller"
            ],
            "operationId" : "getOrders",
            "parameters" : [
              {
                "name" : "cpf_cliente",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "senha_cliente",
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
                      "type" : "array",
                      "items" : {
                        "$ref" : "#/components/schemas/GetOrderResponse"
                      }
                    }
                  }
                }
              }
            },
            "security" : [{ "lambda_authorizer_cpf" : [] }],
            "x-amazon-apigateway-integration" : {
              "httpMethod" : "GET",
              "payloadFormatVersion" : "1.0",
              "requestParameters" : {
                "integration.request.header.microsservice" : "'ms_pedido'"
              },
              "type" : "HTTP_PROXY",
              "uri" : "http://${local.load_balancer_dns}/orders"
            }
          },
          "post" : {
            "tags" : [
              "order-controller"
            ],
            "operationId" : "createOrder",
            "requestBody" : {
              "content" : {
                "application/json" : {
                  "schema" : {
                    "$ref" : "#/components/schemas/CreateOrderRequest"
                  }
                }
              },
              "required" : true
            },
            "parameters" : [
              {
                "name" : "cpf_cliente",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "senha_cliente",
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
                      "$ref" : "#/components/schemas/CreateOrderResponse"
                    }
                  }
                }
              }
            },
            "security" : [{ "lambda_authorizer_cpf" : [] }],
            "x-amazon-apigateway-integration" : {
              "httpMethod" : "POST",
              "payloadFormatVersion" : "1.0",
              "requestParameters" : {
                "integration.request.header.microsservice" : "'ms_orquestrador'"
              },
              "type" : "HTTP_PROXY",
              "uri" : "http://${local.load_balancer_dns}/orders"
            }
          }
        },
        "/customers" : {
          "get" : {
            "tags" : [
              "customer-controller"
            ],
            "operationId" : "getCustomerByCpf",
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
                "name" : "cpf_cliente",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "senha_cliente",
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
            "security" : [{ "lambda_authorizer_cpf" : [] }],
            "x-amazon-apigateway-integration" : {
              "httpMethod" : "GET",
              "payloadFormatVersion" : "1.0",
              "requestParameters" : {
                "integration.request.header.microsservice" : "'ms_cliente'"
              },
              "type" : "HTTP_PROXY",
              "uri" : "http://${local.load_balancer_dns}/customers"
            }
          },
          "post" : {
            "tags" : [
              "customer-controller"
            ],
            "operationId" : "registerCustomer",
            "requestBody" : {
              "content" : {
                "application/json" : {
                  "schema" : {
                    "$ref" : "#/components/schemas/RegisterCustomerRequest"
                  }
                }
              },
              "required" : true
            },
            "parameters" : [
              {
                "name" : "cpf_cliente",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "senha_cliente",
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
                      "$ref" : "#/components/schemas/RegisterCustomerResponse"
                    }
                  }
                }
              }
            },
            "x-amazon-apigateway-integration" : {
              "httpMethod" : "POST",
              "payloadFormatVersion" : "1.0",
              "requestParameters" : {
                "integration.request.header.microsservice" : "'ms_cliente'"
              },
              "type" : "HTTP_PROXY",
              "uri" : "http://${local.load_balancer_dns}/customers"
            }
          }
        },
        "/customers/{id}" : {
          "delete" : {
            "tags" : [
              "customer-controller"
            ],
            "operationId" : "deactivateCustomer",
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
                "name" : "cpf_cliente",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "senha_cliente",
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
            "security" : [{ "lambda_authorizer_cpf" : [] }],
            "x-amazon-apigateway-integration" : {
              "httpMethod" : "DELETE",
              "payloadFormatVersion" : "1.0",
              "requestParameters" : {
                "integration.request.header.microsservice" : "'ms_cliente'",
                "integration.request.header.cpf_cliente" : "method.request.header.cpf_cliente",
                "integration.request.header.senha_cliente" : "method.request.header.senha_cliente",
                "integration.request.path.id" : "method.request.path.id"
              },
              "type" : "HTTP_PROXY",
              "uri" : "http://${local.load_balancer_dns}/customers/{id}"
            }
          }
        }
        "/customers/confirmation" : {
          "post" : {
            "tags" : ["customer-controller"], "operationId" : "confirmSignUp",
            "requestBody" : {
              "content" : {
                "application/json" : { "schema" : { "$ref" : "#/components/schemas/ConfirmSignUpRequest" } }
              }, "required" : true
            },
            "parameters" : [
              {
                "name" : "cpf_cliente",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "senha_cliente",
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
                "integration.request.header.microsservice" : "'ms_cliente'"
              },
              "type" : "HTTP_PROXY",
              "uri" : "http://${local.load_balancer_dns}/customers/confirmation"
            }
          }
        },
        "/payments" : {
          "get" : {
            "tags" : [
              "payment-controller"
            ],
            "operationId" : "findAll",
            "parameters" : [
              {
                "name" : "cpf_cliente",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "senha_cliente",
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
                      "type" : "array",
                      "items" : {
                        "$ref" : "#/components/schemas/PaymentResponse"
                      }
                    }
                  }
                }
              }
            },
            "security" : [{ "lambda_authorizer_cpf" : [] }],
            "x-amazon-apigateway-integration" : {
              "httpMethod" : "GET",
              "payloadFormatVersion" : "1.0",
              "requestParameters" : {
                "integration.request.header.microsservice" : "'ms_pagamento'"
              },
              "type" : "HTTP_PROXY",
              "uri" : "http://${local.load_balancer_dns}/payments"
            }
          }
        },
        "/orders/{orderId}/payment-status" : {
          "get" : {
            "tags" : [
              "order-controller"
            ],
            "operationId" : "getOrderPaymentStatus",
            "parameters" : [
              {
                "name" : "orderId",
                "in" : "path",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "cpf_cliente",
                "in" : "header",
                "required" : true,
                "schema" : {
                  "type" : "string"
                }
              },
              {
                "name" : "senha_cliente",
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
                      "$ref" : "#/components/schemas/GetOrderPaymentStatusResponse"
                    }
                  }
                }
              }
            },
            "security" : [{ "lambda_authorizer_cpf" : [] }],
            "x-amazon-apigateway-integration" : {
              "httpMethod" : "GET",
              "payloadFormatVersion" : "1.0",
              "requestParameters" : {
                "integration.request.path.orderId" : "method.request.path.orderId",
                "integration.request.header.microsservice" : "'ms_pedido'"
              },
              "type" : "HTTP_PROXY",
              "uri" : "http://${local.load_balancer_dns}/payment-status"
            }
          }
        }
      },
      "components" : {
        "schemas" : {
          "UpdateProductRequest" : {
            "required" : [
              "description",
              "name",
              "price",
              "type"
            ],
            "type" : "object",
            "properties" : {
              "name" : {
                "maxLength" : 2147483647,
                "minLength" : 3,
                "type" : "string"
              },
              "price" : {
                "type" : "number"
              },
              "description" : {
                "type" : "string"
              },
              "type" : {
                "type" : "string"
              }
            }
          },
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
          },
          "FullProductResponse" : {
            "type" : "object",
            "properties" : {
              "id" : {
                "type" : "string"
              },
              "name" : {
                "type" : "string"
              },
              "price" : {
                "type" : "number"
              },
              "description" : {
                "type" : "string"
              },
              "type" : {
                "type" : "string"
              },
              "createdAt" : {
                "type" : "string",
                "format" : "date-time"
              },
              "updatedAt" : {
                "type" : "string",
                "format" : "date-time"
              }
            }
          },
          "CreateProductRequest" : {
            "required" : [
              "description",
              "name",
              "price",
              "type"
            ],
            "type" : "object",
            "properties" : {
              "name" : {
                "maxLength" : 2147483647,
                "minLength" : 3,
                "type" : "string"
              },
              "price" : {
                "type" : "number"
              },
              "description" : {
                "type" : "string"
              },
              "type" : {
                "type" : "string"
              }
            }
          },
          "CreateOrderRequest" : {
            "type" : "object",
            "properties" : {
              "customerId" : {
                "type" : "string"
              },
              "items" : {
                "type" : "array",
                "items" : {
                  "$ref" : "#/components/schemas/Item"
                }
              }
            }
          },
          "Item" : {
            "type" : "object",
            "properties" : {
              "idProduct" : {
                "type" : "string"
              },
              "quantity" : {
                "type" : "integer",
                "format" : "int32"
              },
              "itemValue" : {
                "type" : "number"
              },
              "totalItemValue" : {
                "type" : "number"
              }
            }
          },
          "CreateOrderResponse" : {
            "type" : "object",
            "properties" : {
              "customerId" : {
                "type" : "string"
              },
              "items" : {
                "type" : "array",
                "items" : {
                  "$ref" : "#/components/schemas/Item"
                }
              }
            }
          },
          "RegisterCustomerRequest" : {
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
          "RegisterCustomerResponse" : {
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
          },
          "GetOrderResponse" : {
            "type" : "object",
            "properties" : {
              "id" : {
                "type" : "string"
              },
              "items" : {
                "type" : "array",
                "items" : {
                  "$ref" : "#/components/schemas/Item"
                }
              },
              "totalValue" : {
                "type" : "number"
              },
              "createdAt" : {
                "type" : "string",
                "format" : "date-time"
              },
              "updatedAt" : {
                "type" : "string",
                "format" : "date-time"
              },
              "status" : {
                "type" : "string",
                "enum" : [
                  "READY",
                  "IN_PREPARATION",
                  "RECEIVED",
                  "COMPLETED"
                ]
              },
              "paymentStatus" : {
                "type" : "string",
                "enum" : [
                  "PENDING",
                  "APPROVED",
                  "REJECTED"
                ]
              }
            }
          },
          "GetOrderPaymentStatusResponse" : {
            "type" : "object",
            "properties" : {
              "paymentStatus" : {
                "type" : "string",
                "enum" : [
                  "PENDING",
                  "APPROVED",
                  "REJECTED"
                ]
              }
            }
          },
          "GetClientResponse" : {
            "type" : "object",
            "properties" : {
              "id" : {
                "type" : "string"
              },
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
              },
              "creationTimestamp" : {
                "type" : "string",
                "format" : "date-time"
              },
              "updateTimestamp" : {
                "type" : "string",
                "format" : "date-time"
              }
            }
          },
          "PaymentResponse" : {
            "type" : "object",
            "properties" : {
              "id" : {
                "type" : "string"
              },
              "orderId" : {
                "type" : "string"
              },
              "status" : {
                "type" : "string"
              },
              "createAt" : {
                "type" : "string",
                "format" : "date-time"
              }
            }
          }
        },
        "securitySchemes" : {
          "lambda_authorizer_cpf" : {
            "type" : "apiKey",
            "name" : "auth",
            "in" : "header",
            "x-amazon-apigateway-authtype" : "custom",
            "x-amazon-apigateway-authorizer" : {
              "type" : "request",
              "identitySource" : "method.request.header.cpf_cliente, method.request.header.senha_cliente",
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

