class DataMapper::ResourceInspector < Merb::Inspector
  model ::DataMapper::Resource

  def execute
    partial template_for(template), current_options
  end

  def columns
    model.properties
  end

  def edit_columns
    columns.reject{|p| p.type == ::DataMapper::Types::Serial}
  end

  def edit(object, options = {})
    @object  = object
    @options = options
    @mode    = :edit

    execute
  end

  private
    def record_id
      oid = @object.new_record? ? "new" : @object.id
      "#{resource_name}_#{oid}"
    end

    def model
      @object.class
    end

    def template
      if @options[:action].to_s == 'new'
        "new"
      else
        "record"
      end
    end

    def toggle
      "$('##{record_id} .record').toggle();return false;"
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
end


class DataMapper::CollectionInspector < DataMapper::ResourceInspector
  model ::DataMapper::Collection

  def columns
    @object.properties
  end

  private
    def model
      @object.query.model
    end

    def options
      {:model=>model, :records=>@object}
    end

    def template
      "records"
    end
end
