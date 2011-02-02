require File.join(File.dirname(__FILE__), '..', 'config', 'environment')

websocket_config = YAML.load(File.read(Rails.root.join('config', 'websocket.yml')))
config = websocket_config['default'].symbolize_keys

at_exit do
  begin
    File.delete(PID_FILE)
  rescue
    puts 'Cannot remove pidfile: ' + (PID_FILE ? PID_FILE : "NIL")
  end
end

def write_pidfile
  begin
    f = File.open(PID_FILE, "w")
    f.write(Process.pid)
    f.close
  rescue => e
    puts "Can't write to pidfile!"
    puts e.inspect
  end
end

def debug_pp thing
  pp thing if config[:socket_debug] || ENV['SOCKET_DEBUG']
end

begin
  EM.run {
    socket_params = { :host => config[:socket_host],
                      :port => config[:socket_port],
                      :debug =>config[:socket_debug] }

    if config[:socket_secure] && config[:socket_private_key_location] && config[:socket_cert_chain_location]
      socket_params[:secure] = true;
      socket_params[:tls_options] = {
                    :private_key_file => config[:socket_private_key_location],
                    :cert_chain_file  => config[:socket_cert_chain_location]
      }
    end

    EventMachine::WebSocket.start( socket_params ) do |ws|

      ws.onopen {
        begin
          debug_pp ws.request

          ws.onmessage { |msg| debug_pp msg }

          ws.onclose {
            begin
              debug_pp "Closing websocket"
            rescue
              debug_pp "Could not close socket"
            end
          }
        rescue RuntimeError => e
          debug_pp "Could not open socket for request with cookie: #{ws.request["Cookie"]}"
          debug_pp "Error was: "
          debug_pp e
        end
      }
    end
    PID_FILE = (config[:socket_pidfile] ? config[:socket_pidfile] : 'tmp/pids/wss.pid')
    write_pidfile
    puts "Websocket server started."
    #process_message
  }
rescue RuntimeError => e
  raise e unless e.message.include?("no acceptor")
  puts "Are you sure the websocket server isn't already running?"
  puts "Just start thin with bundle exec thin start."
  Process.exit
end
