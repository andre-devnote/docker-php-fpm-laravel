# docker-php-fpm-laravel

Imagem estendida do [php:7.2-fpm](https://github.com/docker-library/php/blob/f363b9f8a0e23e79faaa624ff5bf160b9dec18f4/7.2/stretch/fpm/Dockerfile) com a adição de algumas utilities para desenvolvimento com Laravel.

*Observação:* A intenção dessa imagem é facilitar a criação de ambientes de desenvolvimento. **Não utilizar em produção** sem fazer os ajustes necessários ([veja abaixo](#producao)).

## Como usar?

TODO

A forma mais simples é:

`docker run --rm -d -p 8000:8000 devnote/php-fpm-laravel:7.2-dev`

TODO

## O que está instalado na imagem?

- [composer](https://getcomposer.org/)

- [procps](https://packages.debian.org/stretch/procps) (utilitários para o /proc; comandos "top", "ps", "uptime", "kill" etc)

- [supervisor](https://packages.debian.org/stretch/supervisor) (para startar e manter rodando o php-fpm, o queue worker do Laravel e o built-in server do PHP)

- [imagemagick](https://packages.debian.org/stretch/imagemagick)

- [zip](https://packages.debian.org/stretch/zip) e [unzip](https://packages.debian.org/stretch/unzip)

Também foram instalados os seguintes módulos do PHP:

- `bcmath`
- `calendar`
- `exif`
- `gd`
- `intl`
- `mysqli`
- `opcache`
- `pdo_mysql`
- `soap`
- `xsl`
- `zip`
- `imagick` (pecl)
- `mcrypt-1.0.1` (pecl)
- `redis` (pecl)

O timezone do sistema está configurado como "America/Sao_Paulo" e o umask padrão é 002 (novos arquivos criados como 775).

## <a id="producao"></a>Posso usar essa imagem em produção?

TODO