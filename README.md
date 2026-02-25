# Automatización API Karate (Petstore Swagger)

Este proyecto contiene la automatización de pruebas para los endpoints `store` y `user` de la API de Swagger Petstore, utilizando Karate DSL y Maven. 

Todo el framework está implementado bajo un enfoque **Data-Driven Testing (DDT)**, aprovechando las ventajas de `Scenario Outline` y las tablas de datos (Examples) para maximizar la cobertura de pruebas minimizando el código repetitivo.

## Estructura del Proyecto

Las pruebas están organizadas por funcionalidades dentro del directorio `src/test/java/com/pruebaTecnicaBackend/`:
- **store**: Contiene `store.feature` con validaciones de caminos felices y de errores para operaciones sobre las órdenes de compra. Ahora soporta casos iterativos variados.
- **user**: Contiene `user.feature` con validaciones de creación (`createWithList`, `createWithArray`, POST), actualización, lectura, inicio y cierre de sesión de usuarios, además de validaciones de credenciales erróneas controladas.

Cada base cuenta con una clase Runner de JUnit 5 (ej. `StoreRunner.java` y `UserRunner.java`) que permite ejecutar las pruebas asociadas.

## Configuración y Entornos

El archivo principal de configuración de Karate es `src/test/java/karate-config.js`. Contiene la URL base preconfigurada:
- `baseUrl`: `https://petstore.swagger.io/v2`

Por defecto, la ejecución tomará el entorno `dev`, pero se inyectan propiedades para el entorno certificado así:
```bash
mvn test -Dkarate.env=cert
```

## Ejecución de Pruebas

Debes tener Apache Maven instalado y debidamente configurado en tus variables de entorno, además de JDK 17 o superior.

### Ejecutar todas las suites combinadas (El proyecto completo)
Para ejecutar **todos** los features en todo el proyecto asegurando que Maven detecte todos los Runners, usa:
```bash
mvn clean test -Dtest="*Runner" -Dkarate.env=cert
```

### Ejecutar pruebas específicas por nombre de Runner
Si deseas ejecutar la suite particular de "Store" **Y** de "User" al mismo tiempo pasando los nombres explícitamente:
```bash
mvn clean test -Dtest=StoreRunner,UserRunner -Dkarate.env=cert
```

### Ejecutar pruebas por etiquetas (Tags)
En los archivos `.feature`, se ha hecho uso de _tags_ (etiquetas) para discriminar los casos. 
Las etiquetas disponibles son:
- `@store`: Todos los casos relacionados con las órdenes (API de Tienda).
- `@user`: Todos los casos relacionados con la gestión de perfiles (API de Usuarios).
- `@happy-path`: Casos de validación con éxito esperado (códigos 200 OK).
- `@unhappy-path`: Casos negativos, validaciones de IDs inválidos, carga vacía, etc (códigos 400 y 404).

Ejemplo para ejecutar únicamente pruebas de `store` y que correspondan a casos `happy-path`:
```bash
mvn clean test -Dtest=StoreRunner -Dkarate.options="--tags @store,@happy-path" -Dkarate.env=cert
```

O para ejecutar solo los flujos de error (unhappy paths) de la API de Usuarios:
```bash
mvn clean test -Dtest=UserRunner -Dkarate.options="--tags @user,@unhappy-path" -Dkarate.env=cert
```

## Reportes Consolidados
Al finalizar la corrida de las pruebas (independientemente si ejecutaste una o varias suites juntas), los resultados de ejecución generales se consolidarán en la ruta:
`target/karate-reports/karate-summary.html`. 

Para consultar los reportes visuales con el detalle de las peticiones a la API, basta con abrir ese archivo en tu navegador web de preferencia.
