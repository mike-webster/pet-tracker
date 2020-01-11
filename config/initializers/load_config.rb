CONFIG_PATH = Rails.root.join('config', 'config.yml').freeze unless defined? CONFIG_PATH
# rubocop:disable YAMLLoad
APP_CONFIG = YAML.load(ERB.new(File.read(CONFIG_PATH)).result)[Rails.env] unless defined? APP_CONFIG