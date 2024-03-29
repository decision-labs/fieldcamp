rails_env   = ENV['RAILS_ENV']  || "production"
rails_root  = ENV['RAILS_ROOT'] || "/data/shoaib/caritas/current"

God.watch do |w|
  w.name     = 'caritas-websocket-task'
  w.group    = 'caritas-websocket-group'
  w.interval = 30.seconds
  w.env      = {"RAILS_ENV"=>rails_env,"RAILS_ROOT"=>rails_root}
  w.start    = "/opt/ruby-enterprise/bin/ruby #{rails_root}/script/websocket_server.rb"
  w.pid_file = "#{rails_root}/tmp/pids/caritas-wss.pid"
  w.stop = "kill `cat #{rails_root}/tmp/pids/caritas-wss.pid`"

  w.uid = 'shoaib'
  w.gid = 'shoaib'

  # restart if memory gets too high
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.above = 350.megabytes
      c.times = 2
    end
  end

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.running = false
    end
  end
end
