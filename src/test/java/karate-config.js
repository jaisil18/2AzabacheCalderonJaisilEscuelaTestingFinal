function fn() {
  var env = karate.env;  // get system property 'karate.env'
  karate.log('la propiedad del sistema karate.env fue:', env);
  if (!env) {
    env = 'dev';
  }

  // Configurar las variables por defecto
  var config = {
    env: env,
    baseUrl: 'https://petstore.swagger.io/v2'
  };

  if (env == 'dev') {
    // defaults already set
  } else if (env == 'cert') {
    // customize
  }
  // Configurando los tiempos de espera de conexión y lectura
  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);

  return config;
}