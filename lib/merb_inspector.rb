# make sure we're running inside Merb
if defined?(Merb::Plugins)

  $: << File.dirname(__FILE__) unless $:.include?(File.dirname(__FILE__))
  
  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  Merb::Plugins.config[:merb_inspector] = {
    :chickens => false
  }
  
  Merb::BootLoader.before_app_loads do
    require "merb_inspector" / "inspector"
    require "merb_inspector" / "data"
    require "merb_inspector" / "builtin"
    require "merb_inspector" / "manager"
    require "merb_inspector" / "helper"

    Merb::Inspector::Manager.reset
    Merb::Inspector::Manager.install
  end
  
  Merb::BootLoader.after_app_loads do

#     class ::Application
#       include Merb::Inspector::Helper
#     end
  end
  
  Merb::Plugins.add_rakefiles "merb_inspector/merbtasks"
end
