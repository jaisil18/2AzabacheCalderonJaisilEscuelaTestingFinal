Feature: Automatización de la API Store (Swagger Petstore)

  Background:
    * url baseUrl

    @store @happy-path
  Scenario Outline: Realizar órdenes de compra con distintos estados - <estado>
    Given path 'store', 'order'
    And request
    """
    {
      "id": <ordenId>,
      "petId": 10,
      "quantity": 2,
      "shipDate": "2026-02-24T00:00:00.000Z",
      "status": "<estado>",
      "complete": <completado>
    }
    """
    When method post
    Then status 200
    And match response.status == '<estado>'
    * print response

    Examples:
      | ordenId | estado   | completado |
      | 100     | placed   | false      |
      | 101     | approved | true       |
      | 102     | delivered| true       |

    @store @happy-path
  Scenario Outline: Buscar múltiples órdenes válidas por ID - <orderId>
    Given path 'store', 'order', <orderId>
    When method get
    Then status 200
    And match response.id == <orderId>
    * print response

    Examples:
      | orderId |
      | 100     |
      | 101     |
      | 102     |

    @store @happy-path
  Scenario: Retornar los inventarios de mascotas por estado
    Given path 'store', 'inventory'
    When method get
    Then status 200
    And match responseType == 'json'
    * print response

    @store @happy-path
  Scenario Outline: Eliminar múltiples órdenes válidas por ID - <orderId>
    Given path 'store', 'order', <orderId>
    When method delete
    Then status 200
    And match response.message == String(<orderId>)
    * print response

    Examples:
      | orderId |
      | 100     |
      | 101     |
      | 102     |

      #/////////////////////////////////////////////////////////

    @store @unhappy-path
  Scenario Outline: Buscar una orden con formatos de ID inválidos: <idInvalido>
    Given path 'store', 'order', '<idInvalido>'
    When method get
    Then status 404
    * print response

    Examples:
      | idInvalido | descripcion          |
      | abcde      | Solo letras         |
      | 999999e    | Notación científica |
      | 12.5       | Número decimal      |
      | @#$%%      | Caracteres esp.      |

    @store @unhappy-path
  Scenario Outline: Fallo al crear orden por datos inválidos - Campo: <campo>
    Given path 'store', 'order'
    And request 
    """
    {
      "id": 1,
      "petId": <petIdInput>,
      "quantity": <cantidadInput>,
      "status": "placed",
      "complete": true
    }
    """
    When method post
    Then status 500
    * print response

    Examples:
      | campo    | petIdInput | cantidadInput |
      | petId    | "perro"    | 1             |
      | quantity | 10         | "tres"        |
