module EventBus
  class Daemon
    INTERRUPTION_SIGNALS = %w(TERM INT)

    def self.start
      Listeners::Manager.bind_all_listeners

      bind_signals
    end

    def self.stop
      EventBus::Config.broker.close_connection

      exit
    end

    def self.bind_signals
      read, write = IO.pipe

      INTERRUPTION_SIGNALS.each do |signal|
        Signal.trap(signal) { write.puts(signal) }
      end

      begin
        while io = IO.select([read])
          signal = io.first[0].gets.strip
          raise Interrupt if INTERRUPTION_SIGNALS.include?(signal)
        end
      rescue Interrupt
        stop
      end
    end
  end
end
