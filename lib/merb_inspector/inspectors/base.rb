module Merb
  module Inspectors
    class Base
      class << self
        def register(klass)
          Merb::Inspector.register(klass, self)
        end
      end

      def initialize(object, caller, options = {})
        @object  = object
        @caller  = caller
        @options = options
        @options = {:action=>@options} unless @options.is_a?(Hash)
#        @context = context || binding # not used yet
      end

      def execute
        @object.inspect
      end

      private
        def name
          self.class.name.sub(/^Merb::Inspectors::/,'').sub(/Inspector$/,'').underscore
        end

        def dir
          File.join Merb::Inspector.root, "templates", name
        end

        def id
          @object.object_id
        end

        def template_for(name)
          File.join dir, name
        end

        def partial(name)
          @caller.send :partial, template_for(name), current_options
        end

        def current_options
          basic_options.merge(options)
        end

        def options
          {}
        end

        def basic_options
          {:inspector=>self, :options=>@options, :dir=>dir, :id=>id}
        end

        def method_missing(*args, &block)
          @caller.send(*args, &block)
        end
    end
  end
end
