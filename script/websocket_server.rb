require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
# require File.join(File.dirname(__FILE__), '..', 'lib', 'web_socket') # should be loaded when rails env is loaded

websocket_config = YAML.load(File.read(Rails.root.join('config', 'websocket.yml')))
WebSocketConfig = websocket_config[Rails.env].symbolize_keys

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
  pp thing if WebSocketConfig[:socket_debug] || ENV['SOCKET_DEBUG']
end

def process_message
  if Caritas::WebSocket.length > 0
    message = Caritas::WebSocket.next
    if message
      Caritas::WebSocket.broadcast(message)
    end
    EM.next_tick{process_message}
  else
    EM::Timer.new(1){process_message}
  end
end

begin
  EM.run {
    Caritas::WebSocket.initialize_channel

    socket_params = { :host => WebSocketConfig[:socket_host],
                      :port => WebSocketConfig[:socket_port],
                      :debug =>WebSocketConfig[:socket_debug] }


    if WebSocketConfig[:socket_secure] && WebSocketConfig[:socket_private_key_location] && WebSocketConfig[:socket_cert_chain_location]
      socket_params[:secure] = true;
      socket_params[:tls_options] = {
                    :private_key_file => WebSocketConfig[:socket_private_key_location],
                    :cert_chain_file  => WebSocketConfig[:socket_cert_chain_location]
      }
    end

    EventMachine::WebSocket.start( socket_params ) do |ws|

      ws.onopen {
        begin
          debug_pp ws.request
          sid = Caritas::WebSocket.subscribe(ws)

          ws.onmessage { |msg| debug_pp msg }

          ws.onclose {
            begin
              debug_pp "Closing websocket"
              Caritas::WebSocket.unsubscribe(sid)
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
    PID_FILE = (WebSocketConfig[:socket_pidfile] ? WebSocketConfig[:socket_pidfile] : ENV['RAILS_ROOT']+'/tmp/pids/wss.pid')
    write_pidfile
    puts "Websocket server started."
    process_message
  }
rescue RuntimeError => e
  raise e unless e.message.include?("no acceptor")
  puts "Are you sure the websocket server isn't already running?"
  Process.exit
end
