Websocket_config = YAML.load(File.read(Rails.root.join('config', 'websocket.yml')))['default'].symbolize_keys
