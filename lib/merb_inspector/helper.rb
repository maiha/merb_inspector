module Merb
  class Inspector
    module Helper
      def inspect(*args)
        return h(super()) if args.blank?
        object  = args.shift
        options = args.shift || {}

        unless options.is_a?(Hash)
          action = options.to_s
          options = args.shift || {}
          options[:action] = action
        end
        options[:action]    ||= :show
        options[:level]     ||= 1
        options[:max_level] ||= 3

        # validate keys
        valid_keys   = [:action, :level, :max_level]
        unknown_keys = options.keys - valid_keys
        if !unknown_keys.blank?
          return h("[INSPECTOR ERROR] Unknown key(s): %s" % unknown_keys.inspect)
        end

        inspector_class = BasicInspector if options[:level] >= options[:max_level]
        inspector_class ||= Manager.lookup(object) || Merb::Inspector.default

        inspector = inspector_class.new(Merb::Request.new({}))
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
