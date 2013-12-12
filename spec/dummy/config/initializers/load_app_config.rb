YAML::ENGINE.yamler = "syck" # http://crohr.me/2011/02/23/issue-with-ruby1.9.2-yaml-parser-and-merge-keys-in-yaml-configuration-file.html
APP_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/app_config.yml")[Rails.env]

