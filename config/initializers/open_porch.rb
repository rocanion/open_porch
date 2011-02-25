OPEN_PORCH_VERSION = '0.3.0 (beta)'

open_porch_file = ''
if defined?(OPEN_PORCH_CONFIG_FILE)
  open_porch_file = OPEN_PORCH_CONFIG_FILE 
else
  # Look for a configuration file to load
  path = File.expand_path('./config')
  while (File.exists?(path) and (path != '/'))
    open_porch_file = "#{path}/open_porch.yml"
    if (File.exists?(open_porch_file))
      break
    else
      path = File.expand_path("..", path)
    end
  end
end


if File.exists?(open_porch_file)
  open_porch_config = YAML::load(File.open(open_porch_file))
  env = defined?(Rails) ? Rails.env : RAILS_ENV

  if open_porch_config['openx_zones'] && open_porch_config['openx_zones'][env]
    OPEN_PORCH_ZONES = open_porch_config['openx_zones'][env]
  end

  if open_porch_config['pop3_server'] && open_porch_config['pop3_server'][env]
    OPEN_PORCH_POP3 = open_porch_config['pop3_server'][env]
  end
  
  if open_porch_config['postageapp'] && open_porch_config['postageapp'][env]
    PostageApp.configure do |config|
      open_porch_config['postageapp'][env].each do |key, value|
        config.send("#{key}=", value)
      end
    end
  end
else
  puts "open_porch.yml not found. Looking at: #{open_porch_file}"
end