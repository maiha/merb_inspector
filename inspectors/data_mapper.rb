class DataMapper::ResourceInspector < Merb::Inspector
  builtin
  model ::DataMapper::Resource

  def edit(object, options = {})
    @object  = object
    @options = options
    @mode    = :edit

    execute
  end

  private
    def model
      @object.class
    end

    def klass
      @object.class
    end

    def columns
      @columns ||= build_columns
    end

    def dom_id
      oid = @object.new_record? ? "new" : @object.id
      "#{resource_name}-#{oid}"
    end

    def template
      if @options[:action].to_s == 'new'
        "new"
      else
        "record"
      end
    end

    def save_action
      if @object.new_record?
        "/" + resource_name
      else
        resource(@object)
      end
    end

    def options
      {:model=>model, :record=>@object, :save_action=>save_action, :toggle=>toggle}
    end

    ######################################################################
    ### Resourceful

    def resource_name
      Extlib::Inflection.demodulize(model.name).plural.snake_case
    end

    def link_to_new(label = 'New', opts = {})
      link_to label, resource(resource_name, :new), opts
    rescue Merb::Router::GenerationError
    end

    def show_link_value(record, p, opts = {})
      opts[:label] ||= "Show"
      link_to opts[:label], resource(record), opts
    rescue Merb::Router::GenerationError
    end

    def edit_link_value(record, p, opts = {})
      opts[:label] ||= "Edit"
      link_to opts[:label], resource(record, :edit), opts
    rescue Merb::Router::GenerationError
    end

    def delete_link_value(record, p, opts = {})
      opts[:label] ||= "Delete"
      link_to opts[:label], resource(record, :delete), opts
    rescue Merb::Router::GenerationError
    end

    ######################################################################
    ### form builder for DataMapper

    def default_columns
      [LinkColumn.new(self, :show), LinkColumn.new(self, :edit)]
    end

    def find_column_by_name(name)
      name = name.to_s.intern
      (klass.properties.to_a + default_columns).each do |col|
        return col if col.name == name
      end
      return nil
    end

    def build_columns
      if @options[:only]
        valids = Array(@options[:only]).flatten.compact.map(&:to_sym)
        cols = valids.map{|name| find_column_by_name(name) || name}
      else
        cols = klass.properties.to_a + default_columns
        if @options[:except]
          invalids = Array(@options[:except]).flatten.compact.map(&:to_sym)
          cols = cols.reject{|col| invalids.include?(col.name)}
        end
      end

      cols.map do |col|
        case col
        when ::DataMapper::Property
          DMColumn.new(self, col)
        when Column
          col
        else
          VirtualColumn.new(self, col)
        end
      end
    end

    def column_label(column)
      column.label
    end

    def column_value(record, column)
      column.value(record)
    rescue Column::MethodFound => e
      __send__ *e.args
    rescue Column::NotDefined => e
      call_user_method(e.message, record, column)
    end

    def column_form(record, column)
      column.form(record)
    rescue Column::MethodFound => e
      __send__ *e.args
    rescue Column::NotDefined => e
      call_user_method(e.message, record, column)
    end

    def call_user_method(method, record, column)
      method = method.to_sym
      block  = @options[:columns][method] rescue nil
      if block
        block.call(record, column)
      else
        "[VirtualColumn] '#{method}' is not defined yet"
      end
    end
end


class DataMapper::CollectionInspector < DataMapper::ResourceInspector
  builtin
  model ::DataMapper::Collection, ::DataMapper::Associations::OneToMany::Proxy 

  private
    def model
      @object.query.model
    end

    def klass
      @object
    end

    def options
      {:model=>model, :records=>@object}
    end

    def template
      "records"
    end
end
