module Merb
  class Inspector
    module Helper
      def inspect(object = nil, options = {})
        return super() unless object

        options = options.is_a?(Hash) ? options : {:action=>options}
        options[:action] ||= :show
        options[:level]  ||= 1
        inspector = (Manager.lookup(object) || Merb::Inspector.default).new(Merb::Request.new({}))

        if inspector.respond_to?(options[:action])
          inspector.send options[:action], object, options
        else
          message = "%s doesn't recognize '%s' action" % [inspector.class, options[:action]]
          raise Merb::Inspector::ActionNotFound, message
        end
      end
    end
  end
end

class Merb::Controller
  include Merb::Inspector::Helper
end
