RailsAdmin.model "Administrator" do
  
  navigation_label I18n.t(:administrators, scope: "rails_admin.nav", default: "Administrators")

  object_label do |record|
    record.email
  end

  list do
    field :email
  end

  edit do
    field :email, :string
    field :password
    field :password_confirmation
  end

end
