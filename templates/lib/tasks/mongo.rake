if Rails.env.development?
require 'dotenv/tasks'
end

require 'moped'

def uri_to_command_args(uri, options = {})
  args = ["--host #{uri.hosts.first}", "--db #{uri.database}"]
  if uri.auth_provided?
    args += ["--username #{uri.username}", "--password #{uri.password}"]
  end
  options.each do |k,v|
    args << "--#{k} #{v}"
  end
  args
end

def make_command(name, *args)
  ([name] + args.flatten).join(' ')
end

namespace :mongo do
  
  task backup: :dotenv do
    config = YAML.load(ERB.new(File.read("#{Rails.root}/config/mongoid.yml")).result)
    remoteConfig = Moped::Uri.new(config["production"]["sessions"]["default"]["uri"])
    dump_path = Rails.root.join('db/backup')
    mongodump = make_command 'mongodump', uri_to_command_args(remoteConfig, {out: dump_path})
    
    puts "Executing: #{mongodump}"
    if system mongodump
      puts "Backup of production database done."
    end

  end

  task pull: :dotenv do
    config = YAML.load(ERB.new(File.read("#{Rails.root}/config/mongoid.yml")).result)
    localConfig = Moped::Uri.new(config["development"]["sessions"]["default"]["uri"])
    remoteConfig = Moped::Uri.new(config["production"]["sessions"]["default"]["uri"])

    dump_path = Rails.root.join('tmp/mongo/remote_dump')
    restore_path = File.join(dump_path, remoteConfig.database)

    mongodump = make_command 'mongodump', uri_to_command_args(remoteConfig, {out: dump_path})    
    mongorestore = make_command 'mongorestore', uri_to_command_args(localConfig), "--drop", restore_path

    puts "Executing: #{mongodump}"
    if system mongodump
      puts "Production database dumped"
      puts "Executing: #{mongorestore}"
      if system mongorestore
        puts "Production database copied to development database"
        puts "Done."
      end
    end
  end
  
end


