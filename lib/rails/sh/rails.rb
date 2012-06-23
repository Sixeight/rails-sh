module Rails
  module Sh
    module Rails
      extend Forkable

      class << self
        def init
          before_fork do
            ActiveRecord::Base.remove_connection if defined?(ActiveRecord::Base)
          end
          after_fork do
            ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
          end
        end

        def _invoke(line)
          reload!
          command, *args = line.split(/\s+/)
          ARGV.clear
          ARGV.concat args
          puts "\e[42m$ script/#{command}\e[0m"
          require "commands/#{command}"
        end

        def reload!
          Dispatcher.cleanup_application
          Dispatcher.reload_application
        end

        def sub_commands
          %w(
            about dbconsole plugin server
            console daemons destroy generate runner
            performance/profiler performance/benchmarker
          )
        end
      end
    end
  end
end
