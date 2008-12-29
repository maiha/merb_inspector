class ObjectInspector < Merb::Inspector
  builtin
  private
    def template
      if instance_variables.empty?
        :plain
      else
        :default
      end
    end
end
