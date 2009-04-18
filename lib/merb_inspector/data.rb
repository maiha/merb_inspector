module Merb
  class Inspector
    class Column                # Abstract
      class Delegate < StandardError; end
      class Evaluated < Delegate; end
      class MethodFound < Delegate
        attr_reader :args
        def initialize(*args)
          @args = args
          super("method delegation")
        end
      end

      attr_accessor :context, :name

      def initialize(context, name)
        @context = context
        @name    = name.to_s.intern
      end

      def name
        @name.to_s
      end

      def label(*)
        name
      end

      def value(record)
        # first, search class prefixed method that user override
        evaluate(record, "#{Extlib::Inflection.demodulize(record.class.name)}_#{name}_value")

        # second, search method that user override
        evaluate(record, "#{name}_value")

        # finally, guess form from property type
        raise Evaluated, default_value(record)
      end

      def form(record)
        # first, search class prefixed method that user override
        evaluate(record, "#{Extlib::Inflection.demodulize(record.class.name)}_#{name}_form")

        # second, search method that user override
        evaluate(record, "#{name}_form")

        # finally, guess form from property type
        raise Evaluated, default_form(record)
      end

      private
        def h(str)
          context.h(str)
        end

        def evaluate(record, method)
          raise MethodFound.new(method, record, self) if context.respond_to?(method, true)
        end

        def default_value(record)
          raise NotImplementedError
        end

        def default_form(record)
          raise NotImplementedError
        end

        def not_defined(method)
          "[VirtualColumn] '#{method}' is not defined yet"
        end
    end

    class DMColumn < Column
      def initialize(context, property)
        @context  = context
        @property = property
      end

      def name
        @property.name.to_s
      end

      def type
        @property.type
      end

      def default_value(record)
        value = record.send(name)
        if type == ::DataMapper::Types::Text
          value.to_s.split(/\r?\n/).map{|i| h(i.to_s)}.join("<BR>")
        else
          h(value.to_s)
        end
      end

      def default_form(record)
        if type == ::DataMapper::Types::Serial
          record.send name
        elsif type == ::DataMapper::Types::Text
          raise MethodFound.new(:text_area, name.to_sym)
        else
          raise MethodFound.new(:text_field, name.to_sym)
        end
      end
    end

    class VirtualColumn < Column
      def default_value(record)
        not_defined("#{name}_value")
      end

      def default_form(record)
        not_defined("#{name}_form")
      end
    end

    class LinkColumn < Column
      def default_value(record)
        evaluate(record, "#{name}_link_value")
        not_defined("#{name}_link_value")
      end

      def default_form(record)
        evaluate(record, "#{name}_link_form")
        not_defined("#{name}_link_form")
      end

      def label
        nil
      end
    end
  end
end
