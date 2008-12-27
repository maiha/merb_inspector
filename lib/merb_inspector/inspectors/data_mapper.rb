module Merb
  module Inspectors
    module DataMapper
      module Resourceful
        def resource_name
          model.name.demodulize.plural.underscore
        end

        def link_to_new(label = 'New', opts = {})
          @caller.link_to label, @caller.resource(resource_name, :new), opts
        rescue Merb::Router::GenerationError
        end

        def link_to_show(record = @object, label = 'Show', opts = {})
          @caller.link_to label, @caller.resource(record), opts
        rescue Merb::Router::GenerationError
        end

        def link_to_edit(record = @object, label = 'Edit', opts = {})
          @caller.link_to label, @caller.resource(record, :edit), opts
        rescue Merb::Router::GenerationError
        end
      end

      class CollectionInspector < Base
        register ::DataMapper::Collection
        include  Resourceful

        def execute
          partial "records"
        end

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
      end

      class ResourceInspector < Base
        register ::DataMapper::Resource
        include  Resourceful

        def execute
          partial template
        end

        def columns
          model.properties
        end

        def edit_columns
          columns.reject{|p| p.type == ::DataMapper::Types::Serial}
        end

        private
          def id
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

          def edit
            %w( new edit ).include?(@options[:action].to_s)
          end

          def toggle
            "$('##{id} .record').toggle();return false;"
          end

          def save_action
            if @object.new_record?
              "/" + resource_name
            else
              resource(@object)
            end
          end

          def options
            {:model=>model, :record=>@object, :edit=>edit, :save_action=>save_action, :toggle=>toggle}
          end
      end
    end
  end
end
