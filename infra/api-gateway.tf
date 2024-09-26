locals {
  load_balancer_dns    = var.application_load_balancer_dns
  lambda_authorize_uri = "arn:aws:apigateway:${var.region}:lambda:path/2024-04-22/functions/${var.lambda_arn}/invocations"
}

resource "aws_api_gateway_rest_api" "api_gateway_fiap_postech_hackathon" {
  name        = "api_gateway_fiap_postech"
  description = "API Rest para agendamento de consultas médicas executada no Hackathon da FIAP PosTech Arquitetura de Sistemas"

  body = jsonencode(
    {
      "openapi": "3.0.1",
      "info": {
        "title": "Hackathon PosTech FIAP - Agendamentos",
        "description": "API Rest para agendamento de consultas médicas executada no Hackathon da FIAP PosTech Arquitetura de Sistemas",
        "version": "v1"
      },
      "servers": [
        {
          "url": "http://${local.load_balancer_dns}",
          "description": "Generated server url"
        }
      ],
      "paths": {
        "/": {
          "get": {
            "operationId": "Get",
            "responses": {
              "200": {
                "description": "200 response",
                "headers": {
                  "Access-Control-Allow-Origin": {
                    "schema": {
                      "type": "string"
                    }
                  }
                },
                "content": {}
              }
            },
            "x-amazon-apigateway-integration": {
              "httpMethod": "GET",
              "uri": "http://${local.load_balancer_dns}/",
              "responses": {
                "default": {
                  "statusCode": "200",
                  "responseParameters": {
                    "method.response.header.Access-Control-Allow-Origin": "'*'"
                  }
                }
              },
              "passthroughBehavior": "when_no_match",
              "type": "http"
            }
          },
          "options": {
            "responses": {
              "200": {
                "description": "200 response",
                "headers": {
                  "Access-Control-Allow-Origin": {
                    "schema": {
                      "type": "string"
                    }
                  },
                  "Access-Control-Allow-Methods": {
                    "schema": {
                      "type": "string"
                    }
                  },
                  "Access-Control-Allow-Headers": {
                    "schema": {
                      "type": "string"
                    }
                  }
                },
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/Empty"
                    }
                  }
                }
              }
            },
            "x-amazon-apigateway-integration": {
              "responses": {
                "default": {
                  "statusCode": "200",
                  "responseParameters": {
                    "method.response.header.Access-Control-Allow-Methods": "'GET,OPTIONS'",
                    "method.response.header.Access-Control-Allow-Headers": "'Content-Type,X-Amz-Date,Authorization,X-Api-Key'",
                    "method.response.header.Access-Control-Allow-Origin": "'*'"
                  }
                }
              },
              "requestTemplates": {
                "application/json": "{\"statusCode\": 200}"
              },
              "passthroughBehavior": "when_no_match",
              "type": "mock"
            }
          }
        },
        "/actuator/health": {
          "get": {
            "operationId": "Actuator",
            "responses": {
              "200": {
                "description": "200 response",
                "headers": {
                  "Access-Control-Allow-Origin": {
                    "schema": {
                      "type": "string"
                    }
                  }
                },
                "content": {}
              }
            },
            "x-amazon-apigateway-integration": {
              "httpMethod": "GET",
              "uri": "http://${local.load_balancer_dns}/actuator/health",
              "responses": {
                "default": {
                  "statusCode": "200",
                  "responseParameters": {
                    "method.response.header.Access-Control-Allow-Origin": "'*'"
                  }
                }
              },
              "passthroughBehavior": "when_no_match",
              "type": "http"
            }
          }
        },
        "/appointments": {
          "get": {
            "tags": [
              "appointment-controller"
            ],
            "operationId": "getAppointments",
            "parameters": [
              {
                "name": "patientId",
                "in": "query",
                "required": false,
                "schema": {
                  "type": "string"
                }
              },
              {
                "name": "doctorId",
                "in": "query",
                "required": false,
                "schema": {
                  "type": "string"
                }
              },
              {
                "name": "date",
                "in": "query",
                "required": false,
                "schema": {
                  "type": "string",
                  "format": "date"
                }
              },
              {
                "name": "user_email",
                "in": "header",
                "required": true,
                "schema": {
                  "type": "string"
                }
              },
              {
                "name": "user_pword",
                "in": "header",
                "required": true,
                "schema": {
                  "type": "string"
                }
              }
            ],
            "responses": {
              "400": {
                "description": "Bad Request",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "500": {
                "description": "Internal Server Error",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "200": {
                "description": "Success",
                "content": {
                  "application/json": {
                    "schema": {
                      "type": "array",
                      "items": {
                        "$ref": "#/components/schemas/GetAppointmentResponse"
                      }
                    }
                  }
                }
              },
              "404": {
                "description": "Not Found",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              }
            },
            "security": [
              {
                "lambda_authorizer": []
              }
            ],
            "x-amazon-apigateway-integration": {
              "httpMethod": "GET",
              "requestParameters": {
                "integration.request.header.microsservice": "'ms_agendamento'"
              },
              "payloadFormatVersion": "1.0",
              "type": "HTTP_PROXY",
              "uri": "http://${local.load_balancer_dns}/appointments"
            }
          },
          "post": {
            "tags": [
              "appointment-controller"
            ],
            "operationId": "createAppointment",
            "parameters": [
              {
                "name": "user_email",
                "in": "header",
                "required": true,
                "schema": {
                  "type": "string"
                }
              },
              {
                "name": "user_pword",
                "in": "header",
                "required": true,
                "schema": {
                  "type": "string"
                }
              }
            ],
            "requestBody": {
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/CreateAppointmentRequest"
                  }
                }
              },
              "required": true
            },
            "responses": {
              "400": {
                "description": "Bad Request",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "500": {
                "description": "Internal Server Error",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "201": {
                "description": "Created",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/GetAppointmentResponse"
                    }
                  }
                }
              },
              "404": {
                "description": "Not Found",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              }
            },
            "security": [
              {
                "lambda_authorizer": []
              }
            ],
            "x-amazon-apigateway-integration": {
              "httpMethod": "POST",
              "requestParameters": {
                "integration.request.header.microsservice": "'ms_agendamento'"
              },
              "payloadFormatVersion": "1.0",
              "type": "HTTP_PROXY",
              "uri": "http://${local.load_balancer_dns}/appointments"
            }
          }
        },
        "/authenticate": {
          "post": {
            "tags": [
              "authentication-controller"
            ],
            "operationId": "confirmSignUp",
            "requestBody": {
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/ConfirmSignUpRequest"
                  }
                }
              },
              "required": true
            },
            "responses": {
              "500": {
                "description": "Internal Server Error",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "404": {
                "description": "Not Found",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "400": {
                "description": "Bad Request",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "200": {
                "description": "Success",
                "content": {
                  "application/json": {
                    "schema": {
                      "type": "boolean"
                    }
                  }
                }
              }
            },
            "x-amazon-apigateway-integration": {
              "httpMethod": "POST",
              "requestParameters": {
                "integration.request.header.microsservice": "'ms_usuario'"
              },
              "payloadFormatVersion": "1.0",
              "type": "HTTP_PROXY",
              "uri": "http://${local.load_balancer_dns}/authenticate"
            }
          }
        },
        "/doctors": {
          "get": {
            "tags": [
              "doctor-controller"
            ],
            "operationId": "searchDoctorsBySpecialty",
            "parameters": [
              {
                "name": "medicalSpecialty",
                "in": "query",
                "required": true,
                "schema": {
                  "type": "string",
                  "enum": [
                    "CARDIOLOGISTA",
                    "DERMATOLOGISTA",
                    "GASTROENTEROLOGISTA",
                    "GINECOLOGISTA",
                    "ONCOLOGISTA",
                    "PEDIATRA"
                  ]
                }
              },
              {
                "name": "page",
                "in": "query",
                "required": false,
                "schema": {
                  "type": "integer",
                  "format": "int32",
                  "default": 0
                }
              },
              {
                "name": "size",
                "in": "query",
                "required": false,
                "schema": {
                  "type": "integer",
                  "format": "int32",
                  "default": 10
                }
              },
              {
                "name": "user_email",
                "in": "header",
                "required": true,
                "schema": {
                  "type": "string"
                }
              },
              {
                "name": "user_pword",
                "in": "header",
                "required": true,
                "schema": {
                  "type": "string"
                }
              }
            ],
            "responses": {
              "500": {
                "description": "Internal Server Error",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "404": {
                "description": "Not Found",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "400": {
                "description": "Bad Request",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "200": {
                "description": "Success",
                "content": {
                  "application/json": {
                    "schema": {
                      "type": "array",
                      "items": {
                        "$ref": "#/components/schemas/SearchDoctorResponse"
                      }
                    }
                  }
                }
              }
            },
            "security": [
              {
                "lambda_authorizer": []
              }
            ],
            "x-amazon-apigateway-integration": {
              "httpMethod": "GET",
              "requestParameters": {
                "integration.request.header.microsservice": "'ms_usuario'"
              },
              "payloadFormatVersion": "1.0",
              "type": "HTTP_PROXY",
              "uri": "http://${local.load_balancer_dns}/doctors"
            }
          },
          "post": {
            "tags": [
              "doctor-controller"
            ],
            "operationId": "registerDoctor",
            "requestBody": {
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/RegisterDoctorRequest"
                  }
                }
              },
              "required": true
            },
            "responses": {
              "500": {
                "description": "Internal Server Error",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "404": {
                "description": "Not Found",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "400": {
                "description": "Bad Request",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "201": {
                "description": "Created",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/RegisterUserResponse"
                    }
                  }
                }
              }
            },
            "x-amazon-apigateway-integration": {
              "httpMethod": "POST",
              "requestParameters": {
                "integration.request.header.microsservice": "'ms_usuario'"
              },
              "payloadFormatVersion": "1.0",
              "type": "HTTP_PROXY",
              "uri": "http://${local.load_balancer_dns}/doctors"
            }
          }
        },
        "/doctors/{id}": {
          "get": {
            "tags": [
              "doctor-controller"
            ],
            "operationId": "getDoctorById",
            "parameters": [
              {
                "name": "id",
                "in": "path",
                "required": true,
                "schema": {
                  "type": "string"
                }
              },
              {
                "name": "user_email",
                "in": "header",
                "required": true,
                "schema": {
                  "type": "string"
                }
              },
              {
                "name": "user_pword",
                "in": "header",
                "required": true,
                "schema": {
                  "type": "string"
                }
              }
            ],
            "responses": {
              "500": {
                "description": "Internal Server Error",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "404": {
                "description": "Not Found",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "400": {
                "description": "Bad Request",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "200": {
                "description": "Success",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/GetDoctorResponse"
                    }
                  }
                }
              }
            },
            "security": [
              {
                "lambda_authorizer": []
              }
            ],
            "x-amazon-apigateway-integration": {
              "httpMethod": "GET",
              "payloadFormatVersion": "1.0",
              "requestParameters": {
                "integration.request.header.microsservice": "'ms_usuario'",
                "integration.request.path.id": "method.request.path.id"
              },
              "type": "HTTP_PROXY",
              "uri": "http://${local.load_balancer_dns}/doctors/{id}"
            }
          }
        },
        "/doctors/{id}/timetable": {
          "get": {
            "tags": [
              "doctor-controller"
            ],
            "operationId": "getTimetableByDoctorId",
            "parameters": [
              {
                "name": "id",
                "in": "path",
                "required": true,
                "schema": {
                  "type": "string"
                }
              },
              {
                "name": "user_email",
                "in": "header",
                "required": true,
                "schema": {
                  "type": "string"
                }
              },
              {
                "name": "user_pword",
                "in": "header",
                "required": true,
                "schema": {
                  "type": "string"
                }
              }
            ],
            "responses": {
              "500": {
                "description": "Internal Server Error",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "404": {
                "description": "Not Found",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "400": {
                "description": "Bad Request",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "200": {
                "description": "Success",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/GetDoctorTimetableResponse"
                    }
                  }
                }
              }
            },
            "security": [
              {
                "lambda_authorizer": []
              }
            ],
            "x-amazon-apigateway-integration": {
              "httpMethod": "GET",
              "payloadFormatVersion": "1.0",
              "requestParameters": {
                "integration.request.header.microsservice": "'ms_usuario'",
                "integration.request.path.id": "method.request.path.id"
              },
              "type": "HTTP_PROXY",
              "uri": "http://${local.load_balancer_dns}/doctors/{id}/timetable"
            }
          },
          "put": {
            "tags": [
              "doctor-controller"
            ],
            "operationId": "updateTimetable",
            "parameters": [
              {
                "name": "id",
                "in": "path",
                "required": true,
                "schema": {
                  "type": "string"
                }
              },
              {
                "name": "user_email",
                "in": "header",
                "required": true,
                "schema": {
                  "type": "string"
                }
              },
              {
                "name": "user_pword",
                "in": "header",
                "required": true,
                "schema": {
                  "type": "string"
                }
              }
            ],
            "requestBody": {
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/RegisterDoctorTimetableRequest"
                  }
                }
              },
              "required": true
            },
            "responses": {
              "500": {
                "description": "Internal Server Error",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "404": {
                "description": "Not Found",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "400": {
                "description": "Bad Request",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "200": {
                "description": "Success",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/GetDoctorTimetableResponse"
                    }
                  }
                }
              }
            },
            "security": [
              {
                "lambda_authorizer": []
              }
            ],
            "x-amazon-apigateway-integration": {
              "httpMethod": "PUT",
              "payloadFormatVersion": "1.0",
              "requestParameters": {
                "integration.request.header.microsservice": "'ms_usuario'",
                "integration.request.path.id": "method.request.path.id"
              },
              "type": "HTTP_PROXY",
              "uri": "http://${local.load_balancer_dns}/doctors/{id}/timetable"
            }
          },
          "post": {
            "tags": [
              "doctor-controller"
            ],
            "operationId": "registerTimetable",
            "parameters": [
              {
                "name": "id",
                "in": "path",
                "required": true,
                "schema": {
                  "type": "string"
                }
              },
              {
                "name": "user_email",
                "in": "header",
                "required": true,
                "schema": {
                  "type": "string"
                }
              },
              {
                "name": "user_pword",
                "in": "header",
                "required": true,
                "schema": {
                  "type": "string"
                }
              }
            ],
            "requestBody": {
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/RegisterDoctorTimetableRequest"
                  }
                }
              },
              "required": true
            },
            "responses": {
              "500": {
                "description": "Internal Server Error",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "404": {
                "description": "Not Found",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "400": {
                "description": "Bad Request",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "201": {
                "description": "Created",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/GetDoctorTimetableResponse"
                    }
                  }
                }
              }
            },
            "security": [
              {
                "lambda_authorizer": []
              }
            ],
            "x-amazon-apigateway-integration": {
              "httpMethod": "POST",
              "payloadFormatVersion": "1.0",
              "requestParameters": {
                "integration.request.header.microsservice": "'ms_usuario'",
                "integration.request.path.id": "method.request.path.id"
              },
              "type": "HTTP_PROXY",
              "uri": "http://${local.load_balancer_dns}/doctors/{id}/timetable"
            }
          }
        },
        "/patients": {
          "post": {
            "tags": [
              "patient-controller"
            ],
            "operationId": "registerPatient",
            "requestBody": {
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/RegisterPatientRequest"
                  }
                }
              },
              "required": true
            },
            "responses": {
              "500": {
                "description": "Internal Server Error",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "404": {
                "description": "Not Found",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "400": {
                "description": "Bad Request",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "201": {
                "description": "Created",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/RegisterUserResponse"
                    }
                  }
                }
              }
            },
            "x-amazon-apigateway-integration": {
              "httpMethod": "POST",
              "requestParameters": {
                "integration.request.header.microsservice": "'ms_usuario'"
              },
              "payloadFormatVersion": "1.0",
              "type": "HTTP_PROXY",
              "uri": "http://${local.load_balancer_dns}/patients"
            }
          }
        },
        "/patients/{id}": {
          "get": {
            "tags": [
              "patient-controller"
            ],
            "operationId": "getPatientById",
            "parameters": [
              {
                "name": "id",
                "in": "path",
                "required": true,
                "schema": {
                  "type": "string"
                }
              },
              {
                "name": "user_email",
                "in": "header",
                "required": true,
                "schema": {
                  "type": "string"
                }
              },
              {
                "name": "user_pword",
                "in": "header",
                "required": true,
                "schema": {
                  "type": "string"
                }
              }
            ],
            "responses": {
              "500": {
                "description": "Internal Server Error",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "404": {
                "description": "Not Found",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "400": {
                "description": "Bad Request",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/ExceptionDetails"
                    }
                  }
                }
              },
              "200": {
                "description": "Success",
                "content": {
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/GetPatientResponse"
                    }
                  }
                }
              }
            },
            "security": [
              {
                "lambda_authorizer": []
              }
            ],
            "x-amazon-apigateway-integration": {
              "httpMethod": "GET",
              "requestParameters": {
                "integration.request.header.microsservice": "'ms_usuario'",
                "integration.request.path.id": "method.request.path.id"
              },
              "payloadFormatVersion": "1.0",
              "type": "HTTP_PROXY",
              "uri": "http://${local.load_balancer_dns}/patients/{id}"
            }
          }
        }
      },
      "components": {
        "schemas": {
          "CreateAppointmentRequest": {
            "type": "object",
            "properties": {
              "doctorId": {
                "type": "string"
              },
              "patientId": {
                "type": "string"
              },
              "date": {
                "type": "string",
                "format": "date"
              },
              "timeslot": {
                "type": "string"
              }
            }
          },
          "CustomError": {
            "type": "object",
            "properties": {
              "message": {
                "type": "string"
              },
              "field": {
                "type": "string"
              },
              "attemptedValue": {
                "type": "object"
              }
            }
          },
          "ExceptionDetails": {
            "type": "object",
            "properties": {
              "type": {
                "type": "string"
              },
              "title": {
                "type": "string"
              },
              "code": {
                "type": "string"
              },
              "detail": {
                "type": "string"
              },
              "status": {
                "type": "integer",
                "format": "int32"
              },
              "date": {
                "type": "string",
                "format": "date-time"
              },
              "errors": {
                "type": "array",
                "items": {
                  "$ref": "#/components/schemas/CustomError"
                }
              }
            }
          },
          "GetAppointmentResponse": {
            "type": "object",
            "properties": {
              "id": {
                "type": "string"
              },
              "doctorId": {
                "type": "string"
              },
              "patientId": {
                "type": "string"
              },
              "date": {
                "type": "string",
                "format": "date"
              },
              "timeslot": {
                "type": "string"
              },
              "createdAt": {
                "type": "string",
                "format": "date-time"
              }
            }
          },
          "RegisterDoctorTimetableRequest": {
            "required": [
              "friday",
              "monday",
              "saturday",
              "sunday",
              "thursday",
              "tuesday",
              "wednesday"
            ],
            "type": "object",
            "properties": {
              "sunday": {
                "uniqueItems": true,
                "type": "array",
                "items": {
                  "type": "string"
                }
              },
              "monday": {
                "uniqueItems": true,
                "type": "array",
                "items": {
                  "type": "string"
                }
              },
              "tuesday": {
                "uniqueItems": true,
                "type": "array",
                "items": {
                  "type": "string"
                }
              },
              "wednesday": {
                "uniqueItems": true,
                "type": "array",
                "items": {
                  "type": "string"
                }
              },
              "thursday": {
                "uniqueItems": true,
                "type": "array",
                "items": {
                  "type": "string"
                }
              },
              "friday": {
                "uniqueItems": true,
                "type": "array",
                "items": {
                  "type": "string"
                }
              },
              "saturday": {
                "uniqueItems": true,
                "type": "array",
                "items": {
                  "type": "string"
                }
              }
            }
          },
          "GetDoctorTimetableResponse": {
            "type": "object",
            "properties": {
              "sunday": {
                "uniqueItems": true,
                "type": "array",
                "items": {
                  "type": "string"
                }
              },
              "monday": {
                "uniqueItems": true,
                "type": "array",
                "items": {
                  "type": "string"
                }
              },
              "tuesday": {
                "uniqueItems": true,
                "type": "array",
                "items": {
                  "type": "string"
                }
              },
              "wednesday": {
                "uniqueItems": true,
                "type": "array",
                "items": {
                  "type": "string"
                }
              },
              "thursday": {
                "uniqueItems": true,
                "type": "array",
                "items": {
                  "type": "string"
                }
              },
              "friday": {
                "uniqueItems": true,
                "type": "array",
                "items": {
                  "type": "string"
                }
              },
              "saturday": {
                "uniqueItems": true,
                "type": "array",
                "items": {
                  "type": "string"
                }
              }
            }
          },
          "RegisterPatientRequest": {
            "required": [
              "birthday",
              "contactNumber",
              "cpf",
              "email",
              "name",
              "password"
            ],
            "type": "object",
            "properties": {
              "name": {
                "type": "string"
              },
              "birthday": {
                "type": "string",
                "format": "date"
              },
              "cpf": {
                "maxLength": 2147483647,
                "minLength": 11,
                "type": "string"
              },
              "email": {
                "type": "string"
              },
              "password": {
                "maxLength": 2147483647,
                "minLength": 8,
                "type": "string"
              },
              "contactNumber": {
                "maxLength": 2147483647,
                "minLength": 11,
                "type": "string"
              }
            }
          },
          "RegisterUserResponse": {
            "type": "object",
            "properties": {
              "id": {
                "type": "string"
              }
            }
          },
          "RegisterDoctorRequest": {
            "required": [
              "birthday",
              "contactNumber",
              "cpf",
              "crm",
              "email",
              "medicalSpecialty",
              "name",
              "password"
            ],
            "type": "object",
            "properties": {
              "name": {
                "type": "string"
              },
              "birthday": {
                "type": "string",
                "format": "date"
              },
              "cpf": {
                "maxLength": 2147483647,
                "minLength": 11,
                "type": "string"
              },
              "email": {
                "type": "string"
              },
              "password": {
                "maxLength": 2147483647,
                "minLength": 8,
                "type": "string"
              },
              "contactNumber": {
                "maxLength": 2147483647,
                "minLength": 11,
                "type": "string"
              },
              "crm": {
                "maxLength": 2147483647,
                "minLength": 10,
                "type": "string"
              },
              "medicalSpecialty": {
                "type": "string"
              }
            }
          },
          "ConfirmSignUpRequest": {
            "required": [
              "code",
              "email"
            ],
            "type": "object",
            "properties": {
              "email": {
                "type": "string"
              },
              "code": {
                "type": "string"
              }
            }
          },
          "GetPatientResponse": {
            "type": "object",
            "properties": {
              "id": {
                "type": "string"
              },
              "name": {
                "type": "string"
              },
              "birthday": {
                "type": "string",
                "format": "date"
              },
              "cpf": {
                "type": "string"
              },
              "email": {
                "type": "string"
              },
              "contactNumber": {
                "type": "string"
              },
              "isActive": {
                "type": "boolean"
              }
            }
          },
          "SearchDoctorResponse": {
            "type": "object",
            "properties": {
              "id": {
                "type": "string"
              },
              "name": {
                "type": "string"
              },
              "email": {
                "type": "string"
              },
              "crm": {
                "type": "string"
              },
              "medicalSpecialty": {
                "type": "string"
              }
            }
          },
          "GetDoctorResponse": {
            "type": "object",
            "properties": {
              "id": {
                "type": "string"
              },
              "name": {
                "type": "string"
              },
              "birthday": {
                "type": "string",
                "format": "date"
              },
              "cpf": {
                "type": "string"
              },
              "email": {
                "type": "string"
              },
              "contactNumber": {
                "type": "string"
              },
              "isActive": {
                "type": "boolean"
              },
              "crm": {
                "type": "string"
              },
              "medicalSpecialty": {
                "type": "string"
              }
            }
          }
        },
        "securitySchemes": {
          "lambda_authorizer": {
            "type": "apiKey",
            "name": "auth",
            "in": "header",
            "x-amazon-apigateway-authtype": "custom",
            "x-amazon-apigateway-authorizer": {
              "type": "request",
              "identitySource": "method.request.header.user_email, method.request.header.user_pword",
              "authorizerCredentials": var.lab_role_arn,
              "authorizerUri": local.lambda_authorize_uri,
              "authorizerResultTtlInSeconds": 0
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
  rest_api_id = aws_api_gateway_rest_api.api_gateway_fiap_postech_hackathon.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api_gateway_fiap_postech_hackathon.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "postech_stage" {
  deployment_id = aws_api_gateway_deployment.postech_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_fiap_postech_hackathon.id
  stage_name    = "postech_stage"
}

output "api_gateway_id" {
  value = aws_api_gateway_rest_api.api_gateway_fiap_postech_hackathon.id
}

