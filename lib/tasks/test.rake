namespace :test do
    task :info => :environment do
      keys = {}
      keys["secret_key_creds"] = Rails.application.credentials.secret_key_base.present?
      keys["secret_key_env"] = ENV['RAILS_SECRET_KEY']
      keys["master_key_creds"] = Rails.application.credentials.rails_master_key.present?
      keys["master_key_env"] = ENV['RAILS_MASTER_KEY']
      puts keys
    end
  end