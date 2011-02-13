module Caritas
  module WebSocket
    def self.redis
      @redis ||= REDIS
    end

    def self.length
      redis.llen :caritas_websocket
    end

    def self.queue_for_broadcast(data)
      redis.lpush(:caritas_websocket, data.to_json)
    end

    def self.next
      redis.rpop(:caritas_websocket)
    end

    def self.initialize_channel
      @channel = EM::Channel.new
    end

    def self.ensure_channel
      @channel ||= EM::Channel.new
    end

    def self.broadcast(data) # passed data as string
      # FIXME: some reason get's truned to hash notation when sent to browser
      @channel.push(data.to_str) if @channel
    end

    def self.subscribe(ws)
      self.ensure_channel
      @channel.subscribe{ |msg| ws.send msg }
    end

    def self.unsubscribe(sid)
      @channel.unsubscribe(sid)
    end
  end
end