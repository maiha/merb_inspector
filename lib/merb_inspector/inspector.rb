module Merb
  class Inspector < Merb::Controller
    ######################################################################
    ### for exceptins

    class Merb::Inspector::ActionNotFound < Merb::ControllerExceptions::ActionNotFound; end

    ######################################################################
    ### for module

    def self.root
      @root ||= Pathname(File.expand_path(File.dirname(__FILE__) + "/../../"))
    end

    def self.default
      ObjectInspector
    end

    ######################################################################
    ### for class

    def self.model(*models)
      models.each do |model|
        Merb::Inspector::Manager.register(model, self)
      end
    end

    def self.builtin
      include Merb::Inspector::Builtin
    end

    def self.lead(options = {})
      @lead_options = options
    end

    def self.lead_options
      @lead_options
    end

    def show(object, options = {})
      @object  = object
      @options = options

      execute
    end

    private
      def name
        self.class.name.sub(/^Merb::/,'').sub(/Inspector$/,'').snake_case.gsub(/::/, '/')
      end

      def dom_id
        @object.class.name.plural.snake_case.gsub(/::/,'-') + '-' + @object.object_id.to_s
      end

      def toggle
        "$('##{dom_id} > .reversible').toggle();return false;"
      end

      def template_for(name)
        name.to_s
      end

      def main
        partial template_for(template), current_options
      end

      def execute
        if lead?
          wrapped_main
        else
          main
        end
      end

      def close_lead_label
        "[x]"
      end

      def lead_size
        sizes = Array((self.class.lead_options || {})[:size]).compact
        sizes[level-1] || sizes[-1] || 15
      end

      def lead?
        case @options[:lead]
        when NilClass
          self.class.lead_options
        else
          !! @options[:lead]
        end
      end

      def lead
        "<span class=nowrap>%s</span>" % h(@object.inspect.truncate(lead_size))
      end

      def link_to_lead
        link_to close_lead_label, "#", :onclick=>toggle
      end

      def link_to_main
        link_to lead, "#", :onclick=>toggle
      end

      def template
        :default
      end

      def current_options
        basic_options.merge(options)
      end

      def options
        {}
      end

      def level
        @options[:level]
      end

      def basic_options
        {:options=>@options, :level=>level}
      end

      def child_options
        {:level=>@options[:level]+1, :max_level=>@options[:max_level]}
      end

      def wrapped_main
        <<-HTML
<div id="#{dom_id}">
  <div id="#{dom_id}_lead" class="reversible" style="display:block;">
    #{link_to_main}
  </div>
  <div id="#{dom_id}_main" class="reversible" style="display:none;">
    <div style="float:right;">#{link_to_lead}</div>
    #{main}
  </div>
</div>
        HTML
      end
  end

  def self.inspector
    Merb::Inspector
  end
end
