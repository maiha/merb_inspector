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
      if @options[:only]
        klass.properties.select{|p| @options[:only].map(&:to_s).include?(p.name.to_s)}
      elsif @options[:except]
        klass.properties.reject{|p| @options[:except].map(&:to_s).include?(p.name.to_s)}
      else
        klass.properties
      end
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

    def link_to_show(record = @object, label = 'Show', opts = {})
      link_to label, resource(record), opts
    rescue Merb::Router::GenerationError
    end

    def link_to_edit(record = @object, label = 'Edit', opts = {})
      link_to label, resource(record, :edit), opts
    rescue Merb::Router::GenerationError
    end

    ######################################################################
    ### form builder for DataMapper

    def column_header(p)
      label = p.name.to_s
      h(label)
#       link_to label, "#", :onclick=>"return false;"
    end

    def column_value(record, p)
      # first, search class prefixed method that user override
      method = "#{Extlib::Inflection.demodulize(record.class.name)}_#{p.name}_column"
      return send(method, record, p) if respond_to?(method, true)

      # second, search method that user override
      method = "#{p.name}_column"
      return send(method, record, p) if respond_to?(method, true)

      # finally, guess form from property type
      value = record.send(p.name)
      if p.type == ::DataMapper::Types::Text
        value.to_s.split(/\r?\n/).map{|i| h(i.to_s)}.join("<BR>")
      else
        h(value.to_s)
      end
    end

    def column_form(record, p)
      # first, search class prefixed method that user override
      method = "#{Extlib::Inflection.demodulize(record.class.name)}_#{p.name}_form"
      return send(method, record, p) if respond_to?(method, true)

      # second, search method that user override
      method = "#{p.name}_form"
      return send(method, record, p) if respond_to?(method, true)

      # finally, guess form from property type
      if p.type == ::DataMapper::Types::Serial
        record.send p.name
      elsif p.type == ::DataMapper::Types::Text
        text_area p.name
      else
        text_field p.name
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
