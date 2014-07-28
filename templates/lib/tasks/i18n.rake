namespace :i18n do
  task models: :environment do
    default_exclude_fields = [:_id, :id, :_type, :created_at, :updated_at, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip]
    attrs = []
    models = []
    RailsAdmin.config.included_models.each do |class_name|
      models.push class_name.underscore
      cls = class_name.constantize
      attributes = (cls.fields.keys + cls.relations.keys).map(&:to_s) - default_exclude_fields.map(&:to_s)
      attrs += attributes.delete_if{|f| f =~ /_id$/}
    end

    attrs_t = {} 
    
    attrs.uniq.sort.each do |k|
      attrs_t[k] = I18n.t("attributes.#{k}", default: "")
    end

    models_t = {}

    models.each do |k|
      models_t[k] = {
        "one" => I18n.t("mongoid.models.#{k}.one", default: ""),
        "other" => I18n.t("mongoid.models.#{k}.other", default: "")
      }
    end

    res = {
      "#{I18n.default_locale}" => {
        "attributes" => attrs_t,
        "mongoid" => {
          "models" => models_t
        }
      }
    }
    puts res.to_yaml
  end
end