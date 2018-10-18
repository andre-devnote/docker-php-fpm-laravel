# docker-php-fpm-laravel

Imagem estendida do [php:7.2-fpm](https://github.com/docker-library/php/blob/f363b9f8a0e23e79faaa624ff5bf160b9dec18f4/7.2/stretch/fpm/Dockerfile) com a adição de algumas utilities para desenvolvimento com Laravel.

*Observação:* A intenção dessa imagem é facilitar a criação de ambientes de desenvolvimento. **Não utilizar em produção** sem fazer os ajustes necessários ([veja abaixo](#producao)).

## Como usar?

A forma mais simples é:

`docker run --rm -d -p 8000:8000 devnote/php-fpm-laravel:7.2-dev`

É possível desabilitar a inicialização do built-in server do PHP (caso vá usar um container com o Nginx como servidor web, por exemplo) com a variável "DISABLE_BUILTIN_SERVER":

`docker run --rm -d -e "DISABLE_BUILTIN_SERVER=1" --name container_teste devnote/php-fpm-laravel:7.2-dev`

No path da imagem há um script [exec.sh](exec.sh), que funciona como wrapper para setar as permissões de arquivos e diretórios criados/baixados/copiados por algum comando. Por exemplo, ...

`docker exec -ti --user=${UID}:www-data --workdir /var/www/html container_teste exec.sh 'touch um-teste.txt'`

... irá criar um arquivo em /var/www/html/um-teste.txt com as permissões 664 (ou 775, caso fosse um diretório).

### Instalando o Laravel

Substitua */nome/da/pasta* pelo caminho do diretória na sua máquina onde os arquivos ficarão (essa pasta corresponderá ao document root do container)

`docker run -d -v /nome/da/pasta:/var/www/html --name container_laravel devnote/php-fpm-laravel:7.2-dev`

`docker exec -ti --user=${UID}:www-data container_laravel exec.sh 'composer create-project --prefer-dist laravel/laravel .'`


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

A ideia dessa imagem é facilitar o stack de desenvolvimento, então são necessários alguns ajustes para usá-la com segurança em produção:

- Utiliar o umask padrão (022)
- Criar um usuário para o supervisor (hoje roda como root)
- Remover o arquivo supervisor/conf.d/php-server-worker.conf
- Ajustar as permissões da pasta de cache do composer (/.composer)
- Ajustar o timezone (hoje está como "America/Sao_Paulo")
- Em php-fpm.d/www.conf:
    - configurar o "listen" (linha 36) para aceitar conexões apenas do host do nginx
    - descomentar a linha 62 (listen.allowed_clients) e colocar os hosts permitidos