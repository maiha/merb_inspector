module Merb
  class Inspector
    module Manager
      ######################################################################
      ### for module

      class << self
        attr_accessor :stores
        attr_accessor :caches
      end

      def self.reset
        self.stores = Hash.new
        self.caches = Hash.new

        log = Merb.root / "log" / "inspector.log"
        File.unlink log if File.exist?(log)
        load_builtin_inspectors
      end

      def self.load_builtin_inspectors
        inspector_dir = File.dirname(__FILE__) / "../../inspectors"
        Dir["#{inspector_dir}/*.rb"].sort.each do |file|
          begin
            require file
          rescue Exception => error
            message = "[MerbInspector] load error: #{error} (#{error.class})\n#{error.backtraces.first rescue nil}"
            Merb.logger.error message
          end
        end
      end

      def self.log(message)
        path = Merb.root / "log" / "inspector.log"
        message = "[Inspector] %s" % message.to_s.strip
        File.open(path, "a+") {|f| f.puts message}
      end

      def self.register(klass, inspector)
        action = stores.has_key?(klass) ? "overridden" : "registered"
        stores[klass] = inspector
        log "%s %s -> %s" % [action, klass, inspector]
      end

      def self.lookup(object)
        if caches.has_key?(object.class)
          log "lookup: %s => %s (cached)" % [object.class, caches[object.class] || 'nil']
          return caches[object.class]
        end
        klass = object.class.ancestors.find{|klass|
          log "lookup:   %s = %s ... %s" % [object.class, klass, stores[klass]]
          stores.has_key?(klass)
        }
        caches[object.class] = stores[klass]
        if klass
          log "lookup: %s => %s (registered)" % [object.class, caches[object.class]]
        else
          log "lookup: %s => nil (registered as negative cache)" % [object.class]
        end
        return stores[klass]
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
    end
  end
end
