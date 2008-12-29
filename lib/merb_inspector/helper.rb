module Merb
  class Inspector
    module Helper
      def inspect(object = nil, options = {})
        return super() unless object

        options = {:action=>options} if options.is_a?(Symbol)
        action    = options[:action] || :show
        inspector = (Manager.lookup(object) || Merb::Inspector.default).new(Merb::Request.new({}))

        if inspector.respond_to?(action)
          inspector.send action, object, options
        else
          message = "%s doesn't recognize '%s' action" % [inspector.class, action]
          raise Merb::Inspector::ActionNotFound, message
        end
      end
    end
  end
end

class Merb::Controller
  include Merb::Inspector::Helper
end
