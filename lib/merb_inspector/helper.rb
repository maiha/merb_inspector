module Merb
  class Inspector
    module Helper
      def inspect(object = nil, options = {})
        return super() unless object
        inspector = Merb::Inspector.lookup(object) || Merb::Inspector.default
        inspector.new(object, self, options).execute
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
        method = "#{record.class.name.demodulize}_#{p.name}_form"
        return send(method, record, p) if respond_to?(method, true)

        # second, search method that user override
        method = "#{p.name}_form"
        return send(method, record, p) if respond_to?(method, true)

        # second, guess form from property type
        if p.type == DataMapper::Types::Serial
          record.send p.name
        elsif p.type == DataMapper::Types::Text
          text_area p.name
        else
          text_field p.name
        end
      end

      ######################################################################
      ### Patch for broken merb methods

      def xxx_form_for(name, attrs = {}, &blk)
        if !attrs[:action] and defined?(DataMapper::Resource) and name.is_a?(DataMapper::Resource)
          if name.new_record?
            model  = name.class.name.demodulize.snake_case.pluralize.intern
            attrs[:action] = resource(model, :new)
          else
            attrs[:action] = resource(name)
          end
        end
        super(name, attrs, &blk)
      end
    end
  end
end
