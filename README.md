homepros
========

## Heroku Setup

* install the Heroku Toolbelt
* Set the config vars in application.yml (heroku config:add ENV_VAR=value)
* heroku keys:add ~/.ssh/id_rsa.pub
* heroku addons:add heroku-postgresql:dev
* heroku pg:wait
* heroku pg:info
* heroku pgbackups:restore DATABASE 'url-to-s3-mysql.dump'
* heroku labs:enable user-env-compile -a app_name  (for asset_sync precompiling)
* git push heroku master
* heroku run rake db:migrate
* heroku ps:scale web=1
* heroku ps
* heroku logs -ts app

