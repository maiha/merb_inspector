module Merb
  class Inspector
    module Helper
      def inspect(object = nil, options = {})
        return super() unless object
        options = {:action=>options} if options.is_a?(Symbol)
        action    = options[:action] || :show
        inspector = (Manager.lookup(object) || Merb::Inspector.default).new(Merb::Request.new({}))
        inspector.send action, object, options
      end

      def column_header(p)
        label = p.name.to_s
        h(label)
#       link_to label, "#", :onclick=>"return false;"
      end

      def column_value(record, p)
        h(record.send p.name.to_s)
      end

      def column_form(record, p)
        # first, search class prefixed method that user override
        method = "#{Extlib::Inflection.demodulize(record.class.name)}_#{p.name}_form"
        return send(method, record, p) if respond_to?(method, true)

        # second, search method that user override
        method = "#{p.name}_form"
        return send(method, record, p) if respond_to?(method, true)

        # second, guess form from property type
        if p.type == ::DataMapper::Types::Serial
          record.send p.name
        elsif p.type == ::DataMapper::Types::Text
          text_area p.name
        else
          text_field p.name
        end
      end
    end
  end
end
