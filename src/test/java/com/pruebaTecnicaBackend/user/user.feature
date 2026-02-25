Feature: Automatización de la API User (Swagger Petstore)

  Background:
    * url baseUrl

    @user @happy-path
  Scenario Outline: Crear usuarios iterativamente - POST /user
    Given path 'user'
    And request
    """
    {
      "id": <idUsuario>,
      "username": "<username>",
      "firstName": "<nombre>",
      "lastName": "<apellido>",
      "email": "<correo>",
      "password": "<password>",
      "phone": "<telefono>",
      "userStatus": 1
    }
    """
    When method post
    Then status 200
    And match response.type == 'unknown'
    And match response.message == '<idUsuario>'
    * print response

    Examples:
      | idUsuario | username | nombre | apellido | correo           | password | telefono |
      | 123456    | jdoe123  | John   | Doe      | jdoe@email.com   | pass123  | 555-0000 |
      | 123457    | asmith45 | Anna   | Smith    | asmith@email.com | pass456  | 555-0001 |

    @user @happy-path
  Scenario Outline: Crear lista de usuarios con un Array - POST /user/createWithArray
    Given path 'user', 'createWithArray'
    And request
    """
    [
      {
        "id": <id1>,
        "username": "<user1>",
        "firstName": "User1",
        "lastName": "Array",
        "email": "user1@array.com",
        "password": "pwd",
        "phone": "0000",
        "userStatus": 1
      },
      {
        "id": <id2>,
        "username": "<user2>",
        "firstName": "User2",
        "lastName": "Array",
        "email": "user2@array.com",
        "password": "pwd",
        "phone": "0000",
        "userStatus": 1
      }
    ]
    """
    When method post
    Then status 200
    And match response.message == 'ok'
    * print response

    Examples:
      | id1 | user1  | id2 | user2  |
      | 201 | uarr1  | 202 | uarr2  |

    @user @happy-path
  Scenario Outline: Crear lista de usuarios con un List - POST /user/createWithList
    Given path 'user', 'createWithList'
    And request
    """
    [
      {
        "id": <id1>,
        "username": "<user1>",
        "firstName": "User1",
        "lastName": "List",
        "email": "user1@list.com",
        "password": "pwd",
        "phone": "0000",
        "userStatus": 1
      },
      {
        "id": <id2>,
        "username": "<user2>",
        "firstName": "User2",
        "lastName": "List",
        "email": "user2@list.com",
        "password": "pwd",
        "phone": "0000",
        "userStatus": 1
      }
    ]
    """
    When method post
    Then status 200
    And match response.message == 'ok'
    * print response

    Examples:
      | id1 | user1  | id2 | user2  |
      | 301 | ulst1  | 302 | ulst2  |

    @user @happy-path
  Scenario Outline: Iniciar sesión con un usuario existente - GET /user/login
    Given path 'user', 'login'
    And param username = '<username>'
    And param password = '<password>'
    When method get
    Then status 200
    And match response.message contains 'logged in user session'
    * print response

    Examples:
      | username | password |
      | jdoe123  | pass123  |
      | asmith45 | pass456  |

    @user @happy-path
  Scenario Outline: Obtener detalles de usuario mediante username - GET /user/{username}
    Given path 'user', '<username>'
    When method get
    Then status 200
    And match response.username == '<username>'
    * print response

    Examples:
      | username |
      | jdoe123  |
      | asmith45 |

    @user @happy-path
  Scenario Outline: Actualizar usuario existente - PUT /user/{username}
    Given path 'user', '<username>'
    And request
    """
    {
      "id": <idUsuario>,
      "username": "<username>",
      "firstName": "<nombreEdit>",
      "lastName": "Smith",
      "email": "edited@email.com",
      "password": "newpassword",
      "phone": "999-9999",
      "userStatus": 1
    }
    """
    When method put
    Then status 200
    And match response.message == '<idUsuario>'
    * print response

    Examples:
      | username | idUsuario | nombreEdit    |
      | jdoe123  | 123456    | JohnUpdated   |
      | asmith45 | 123457    | AnnaUpdated   |

    @user @happy-path
  Scenario: Cerrar la sesión del usuario actual - GET /user/logout
    Given path 'user', 'logout'
    When method get
    Then status 200
    And match response.message == 'ok'
    * print response

    @user @happy-path
  Scenario Outline: Eliminar usuario mediante username - DELETE /user/{username}
    Given path 'user', '<username>'
    When method delete
    Then status 200
    And match response.message == '<username>'
    * print response

    Examples:
      | username |
      | jdoe123  |
      | asmith45 |


      #/////////////////////////////////////////////////////////

    @user @unhappy-path
  Scenario Outline: Tratar de obtener o eliminar usuario inexistente - <metodo> /user/{username}
    Given path 'user', '<userInv>'
    When method <metodo>
    Then status 404
    * print response

    Examples:
      | metodo | userInv            |
      | get    | nonexistentUser999 |
      | delete | nonexistentUser999 |
      | get    | %$#@@@!!!          |
      | delete | null_user_test     |
    
    @user @unhappy-path
  Scenario Outline: Intentar iniciar sesión con credenciales o parámetros incorrectos - GET /user/login
    Given path 'user', 'login'
    And param username = '<usr>'
    And param password = '<pwd>'
    When method get
    Then status 200
    And match response.message contains 'logged in user session'
    * print response

    Examples:
      | usr           | pwd       | descripcion               |
      | jdoe123       | wrongpass | Password incorrecto       |
      | not_exist     | pass123   | Usuario no existe         |
      |               | pass123   | Username vacío            |
      | jdoe123       |           | Password vacío            |
