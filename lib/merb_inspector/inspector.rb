module Merb
  # A convinient way to get at Merb::Cache
  def self.inspector
    Merb::Inspector
  end

  module Inspector

    def self.root
      @root ||= File.expand_path(File.dirname(__FILE__) + "/../../")
    end

    def self.default
      Merb::Inspectors::Base
    end

    class << self
      attr_accessor :stores
      attr_accessor :caches
    end

    self.stores = Hash.new
    self.caches = Hash.new

    def self.reset
      @caches = Hash.new
    end

    def self.register(klass, inspector)
      raise "#{klass} inspector already setup" if @stores.has_key?(klass)
      @stores[klass] = inspector
      log "registered %s -> %s" % [klass, inspector]
    end

    def self.lookup(object)
      if @caches.has_key?(object.class)
        log "lookup: %s => %s (cached)" % [object.class, @caches[object.class] || 'nil']
        return @caches[object.class]
      end
      klass = object.class.ancestors.find{|klass|
        log "lookup:   %s = %s ... %s" % [object.class, klass, @stores[klass]]
        @stores.has_key?(klass)
      }
      @caches[object.class] = @stores[klass]
      if klass
        log "lookup: %s => %s (registered)" % [object.class, @caches[object.class]]
      else
        log "lookup: %s => nil (registered as negative cache)" % [object.class]
      end
      return @stores[klass]
    end

    def self.log(message)
      path = Merb.root / "log" / "inspector.log"
      message = "[Inspector] %s" % message.to_s.strip
      File.open(path, "a+") {|f| f.puts message}
    end
  end
end

