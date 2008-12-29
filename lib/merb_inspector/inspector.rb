module Merb
  class Inspector < Application
    ######################################################################
    ### for module

    def self.root
      @root ||= Pathname(File.expand_path(File.dirname(__FILE__) + "/../../"))
    end

    def self.default
      Inspector
    end

    def self.log(message)
      path = Merb.root / "log" / "inspector.log"
      message = "[Inspector] %s" % message.to_s.strip
      File.open(path, "a+") {|f| f.puts message}
    end

    def self.model(model, inspector = self)
      Merb::Inspector::Manager.register(model, inspector)
    end

    ######################################################################
    ### for class

    def show(object, options = {})
      @object  = object
      @options = options

      execute
    end

    def execute
      return "(merb inspector)[%s]" % h(@object.inspect)
    end

    private
      def name
        self.class.name.sub(/^Merb::Inspectors::/,'').sub(/Inspector$/,'').snake_case.gsub(/::/, '/')
      end

      def dir
        Merb::Inspector.root + "templates" + name
      end

      def template_for(name)
        dir + name
      end

      def current_options
        basic_options.merge(options)
      end

      def options
        {}
      end

      def basic_options
        {:inspector=>self, :options=>@options, :dir=>dir, :id=>@object.object_id}
      end
  end

  def self.inspector
    Merb::Inspector
  end
end

