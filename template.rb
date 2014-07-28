remove_file "app/assets/javascripts/application.js"
remove_file "app/assets/stylesheets/application.css"
remove_file ".gitignore"
remove_file "db/seeds.rb"

gsub_file 'config/application.rb', /(^|\n)\s*#[^\n]*/, ""
gsub_file 'config/routes.rb', /(^|\n)\s*#[^\n]*/, ""
gsub_file 'Gemfile', /(^|\n)\s*#[^\n]*/, ""
gsub_file 'Gemfile', /(^|\n)(\s*\n+)/, "\n"

insert_into_file "Gemfile", "ruby '2.0.0'\n", :after => "source 'https://rubygems.org'\n"
comment_lines 'Gemfile', "gem 'turbolinks'"

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

@host = ask("Production host:")
@langs = ask("Locales (first will be default):")
@langs = "en" if (@langs.nil? || @langs.blank?)
@langs = @langs.split(/\b/).select {|l| l =~ /[A-z]+/ }
@mail_domain = @host.split('.').last(2).join('.')

@langs_arr_sym = "[" + (@langs.map {|l| ":#{l}" }.join(", ")) + "]"
@langs_arr_str = "[" + (@langs.map {|l| "'#{l}'" }.join(", ")) + "]"
@langs_default_sym = ":#{@langs.first}"


# /*============================
# =            Gems            =
# ============================*/

gem 'mongoid', github: 'mongoid/mongoid'
gem 'rails_admin', github: 'sferik/rails_admin'
gem "ckeditor"
gem "mini_magick"
gem "carrierwave"
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'cloudinary'
gem "devise"
gem 'devise-i18n-views'
gem 'rambler'
gem 'kaminari'
gem 'mongoid_slug'
gem 'mongoid_search'
gem 'mongoid_alize'
gem 'therubyracer'
gem 'less-rails-bootstrap'
gem 'bootstrap-kaminari-views'
gem 'rails_12factor', group: :production
gem 'dotenv-rails', groups: [:development, :test]
gem 'better_rails_admin', github: 'mcasimir/better_rails_admin'


# /*================================================
# =            Environments/Application            =
# ================================================*/

application <<-CODE

    config.i18n.fallbacks = true
    # config.time_zone = 'Europe/Rome'
    config.i18n.default_locale = #{@langs_default_sym}
    config.i18n.available_locales = #{@langs_arr_sym}
CODE


production = <<-CODE

  config.action_mailer.default_url_options = { :host => '#{@host}' }

  ActionMailer::Base.smtp_settings = {
    :port =>           '587',
    :address =>        'smtp.mandrillapp.com',
    :user_name =>      ENV['MANDRILL_USERNAME'],
    :password =>       ENV['MANDRILL_APIKEY'],
    :domain =>         'heroku.com',
    :authentication => :plain
  }
  ActionMailer::Base.delivery_method = :smtp

CODE

environment production, env: 'production'

# /*====================================
# =            Configuration           =
# ====================================*/

file 'config/mongoid.yml', <<-CODE
development:
  sessions:
    default:
      uri: mongodb://localhost:27017/#{@app_name.underscore}

production:
  sessions:
    default:
      uri: <%= ENV['MONGOLAB_URI'] %>
      options:
        max_retries: 30
        retry_interval: 1
        timeout: 15
CODE


# /*====================================
# =            Routes                  =
# ====================================*/

route "mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'"
route "mount Ckeditor::Engine => '/ckeditor'"
route "devise_for :administrators"

directory('templates', '.')
copy_file '_gitignore', '.gitignore'
copy_file '_env', '.env'