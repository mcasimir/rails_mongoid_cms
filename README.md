# Rails Template to create a Ready to use cloud CMS.

- RailsAdmin
- better_rails_admin: Patches for RailsAdmin to fix some bugs and add some useful features
- Mongoid
- Devise
- Ckeditor
- Cloudinary
- Mandrill
- MongoLab
- Heroku
- Carrierwave
- DotEnv
- Mongoid Essentials:
  - denormalize
  - slug
  - full text search

Tasks:
- Backup remote database
- Pull remote database to local
- Dump untranslated model and attributes

## Usage

``` bash
mkdir ~/rails_templates
git clone https://github.com/mcasimir/rails_mongoid_cms.git ~/rails_templates/mongoid_cms
rails new APP_NAME -o -m ~/rails_templates/mongoid_cms/template.rb
```

Initialize git repo

```
cd APP_NAME
git init
```

Create a new heroku app

```
heroku create APP_NAME
```

Setup heroku addons

``` bash
heroku addons:add cloudinary
heroku addons:add mandrill
heroku addons:add mongolab
```

Clone ENV from heroku

``` bash 
heroku config -s | grep -E 'CLOUDINARY|MONGOLAB|MANDRILL' > .env
```