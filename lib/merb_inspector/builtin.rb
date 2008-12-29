module Merb
  class Inspector
    module Builtin
      private
        def dir
          Merb::Inspector.root + "templates" + name
        end

        def template_for(name)
          dir + name.to_s
        end
    end
  end
end
