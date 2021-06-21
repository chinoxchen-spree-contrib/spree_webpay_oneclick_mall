SpreeWebpayOneclickMall
=======================

Integración de  Webpay Oneclick Mall como método de pago para Spree > 4.0

Instalación
------------

Añadir spree_webpay_oneclick_mall a tu Gemfile:

```ruby
  gem 'spree_webpay_oneclick_mall', github: '[your-github-handle]/spree_webpay_oneclick_mall'
```

Instalar dependencias y ejecutar generador:

```shell
bundle
bundle exec rails g spree_webpay_oneclick_mall:install
```

Correr migraciones

```shell
bundle exec rake db:migrate
```

Subscripciones

Para poder manejar las subscripciones de un usuario, utilizar la ruta `oneclick_mall_unsubscription_path`


Tarjetas para ambiente de pruebas
--------------------------------

- Crédito Visa (aprobado):

  - Nº: 4051885600446623
  - Año Expiración: Cualquiera
  - Mes Expiración: Cualquiera
  - CVV: 123

- Crédito Mastercard (rechazado):

  - Nº: 5186059559590568
  - Año Expiración: Cualquiera
  - Mes Expiración: Cualquiera
  - CVV: 123

Luego autenticar con el RUT **11.111.111-1** y clave **123**

## Contributing

If you'd like to contribute, please take a look at the
[instructions](CONTRIBUTING.md) for installing dependencies and crafting a good
pull request.

Copyright (c) 2020 [name of extension creator], released under the New BSD License
