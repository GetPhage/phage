# https://github.com/turboladen/playful/issues/17

module Playful
  class ControlPoint

    # Handling ill-formed descriptions
    class Base

      alias_method :org_get_description, :get_description

      def get_description(location, description_getter)
        class << description_getter

          alias_method :org_set_deferred_status, :set_deferred_status
          def set_deferred_status status, *args
            if :succeeded == status and not args.empty? and args[0].empty?
              #puts "BUG => Playfull tried to examine an empty response"
              org_set_deferred_status :failed
            else
              begin
                org_set_deferred_status status, *args
              rescue => e
                puts "Error while discovering device #{e.message}"
                puts e.backtrace
              end
            end
          end
        end
        org_get_description location, description_getter
      end
    end

    class Device
      alias_method :org_fetch, :fetch

      def fetch
        begin
          org_fetch
        rescue => e
          puts "Error while discovering device #{e.message}"
          puts e.backtrace
        end
      end
    end

    # Ignoring puts messages (sent each time network is controlled)
    def puts msg
    end
  end
end
