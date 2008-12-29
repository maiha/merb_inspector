module Merb
  class Inspector < Merb::Controller
    ######################################################################
    ### for exceptins

    class Merb::Inspector::ActionNotFound < Merb::ControllerExceptions::ActionNotFound; end

    ######################################################################
    ### for module

    def self.root
      @root ||= Pathname(File.expand_path(File.dirname(__FILE__) + "/../../"))
    end

    def self.default
      Inspector
    end

    ######################################################################
    ### for class

    def self.model(model, inspector = self)
      Merb::Inspector::Manager.register(model, inspector)
    end

    def show(object, options = {})
      @object  = object
      @options = options

      execute
    end

    private
      def name
        self.class.name.sub(/^Merb::/,'').sub(/Inspector$/,'').snake_case.gsub(/::/, '/')
      end

      def dom_id
        @object.class.name.plural.snake_case.gsub(/::/,'-') + '-' + @object.object_id.to_s
      end

      def toggle
        "$('##{dom_id} .reversible').toggle();return false;"
      end

      def dir
        Merb::Inspector.root + "templates" + name
      end

      def template_for(name)
        dir + name.to_s
      end

      def execute
        partial template_for(template), current_options
      end

      def template
        :default
      end

      def current_options
        basic_options.merge(options)
      end

      def options
        {}
      end

      def basic_options
        {:options=>@options, :level=>@options[:level]}
      end

      def child_options
        {:level=>@options[:level]+1}
      end
  end

  def self.inspector
    Merb::Inspector
  end
end

