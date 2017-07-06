module NetBooter

  module Telnet

    class RevA < TelnetConnection

      def override_options
        {
          :prompt => /^\r>$/n,
          :status_string => 'On'
        }
      end

      def local_statuses
        parse_status @connection.cmd("pshow")
      end

      private

      def authenticate
        sleep 0.1
        @connection.puts(@options[:username])
        sleep 0.1
        @connection.puts(@options[:password])
        @connection.cmd('')
        sleep 0.1
      end

    end

  end

end
