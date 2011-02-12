WebsocketConfig = YAML.load(File.read(Rails.root.join('config', 'websocket.yml')))['default'].symbolize_keys

# Load the module that contains helper methods for communication between Rails, Redis and EM-WebSocket
require File.join(Rails.root, 'lib', 'web_socket')
