# nextcloud-dokku

This simple repo allows you to run a nextcloud instance with dokku using a linked postgres database. It has been tested with nextcloud version 18.0.2.

# Prerequisites

- [Install dokku](http://dokku.viewdocs.io/dokku/getting-started/installation/)
- [Install postgres plugin for dokku](https://github.com/dokku/dokku-postgres)
- Optional: [Install letsencrypt plugin for dokku](https://github.com/dokku/dokku-letsencrypt)

# How to

1. Create your dokku app and the corresponding postgres instance. During creation of the postgres instance, you'll be displayed the credentials for your postgres database.

```
dokku apps:create your-dokku-app
dokku postgres:create your-postgres-db
dokku postgres:link your-postgres-db your-dokku-app
```

2. Set up the dokku proxy to forward port 9000 which is used inside the nextcloud container.

```
dokku proxy:ports-set your-dokku-app http:80:9000
```

3. Since docker containers are ephemeral and their filesystem is not persistent, you should mount a persistent file system, preferably into the default path of nextcloud. Refering to [dokku docs](https://github.com/dokku/dokku/blob/master/docs/advanced-usage/persistent-storage.md), this can be done with:

```
mkdir -p  /var/lib/dokku/data/storage/your-dokku-app
chown -R dokku:dokku /var/lib/dokku/data/storage/your-dokku-app
chown -R 32767:32767 /var/lib/dokku/data/storage/your-dokku-app
dokku storage:mount your-dokku-app /var/lib/dokku/data/storage/your-dokku-app:/var/www/html
```

4. Now you can clone this repo and deploy it via dokku the usual way.

5. Optional: Activate TLS for your nextcloud instance using letsencrypt + auto-renewal.

```
dokku config:set --global DOKKU_LETSENCRYPT_EMAIL=your@email.tld
dokku letsencrypt your-dokku-app
dokku letsencrypt:cron-job --add
```

6. After deployment, point your browser to your application's URL and configure nextcloud using the postgres option and your credentials from step 1.

7. From time to time, you might want to run the `occ` tool to perform maintenance. This can be done with

```
docker exec --user www-data <nextcloud-container-id> php occ <your-command>
```

# Remarks

The `nginx.conf.sigil` template is from [here](https://github.com/dokku/dokku/blob/master/plugins/nginx-vhosts/templates/nginx.conf.sigil). This existence of this file in the root directory replaces the default dokku nginx config. The file was augmented to increase nginx's `client_max_body_size` in order to allow for larger uploads.

# Known issues

Since the nextcloud-apache runs behind the dokku-nginx, add `overwriteprotocol => "https"` to your nextcloud config.php ([see](https://help.nextcloud.com/t/cannot-grant-access/64566)).
