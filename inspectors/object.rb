class ObjectInspector < Merb::Inspector
  private
    def template
      if instance_variables.empty?
        :plain
      else
        :default
      end
    end
end
