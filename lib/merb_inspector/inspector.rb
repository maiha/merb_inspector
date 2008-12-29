module Merb
  class Inspector < Application
#    include Merb::Inspector::Helper

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

    def self.register(*args)
      Merb::Inspector::Manager.register(*args)
    end

    ######################################################################
    ### Install

    def self.install
      mirror("public/stylesheets")
    end

    def self.mirror(dir)
      source_dir = File.join(File.dirname(__FILE__), '..', '..', 'mirror', dir)
      target_dir = File.join(Merb.root, dir)
      FileUtils.mkdir_p(target_dir) unless File.exist?(target_dir)

      Dir[source_dir + "/*"].each do |src|
        time = File.mtime(src)
        file = File.basename(src)
        dst  = File.join(target_dir, file)

        next if File.directory?(src)
        next if File.exist?(dst) and File.mtime(dst) >= time
        FileUtils.copy(src, dst)
        File.utime(time, time, dst)
        command = File.exist?(dst) ? "update" : "install"
        log "#{command}: #{dir}/#{file}"
      end
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

