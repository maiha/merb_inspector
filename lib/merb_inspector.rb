# make sure we're running inside Merb
if defined?(Merb::Plugins)

  $: << File.dirname(__FILE__) unless $:.include?(File.dirname(__FILE__))
  
  require "merb_inspector" / "inspector"
  require "merb_inspector" / "helper"
  require "merb_inspector" / "inspectors" / "base"

  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  Merb::Plugins.config[:merb_inspector] = {
    :chickens => false
  }
  
  Merb::BootLoader.before_app_loads do
    # require code that must be loaded before the application
  end
  
  Merb::BootLoader.after_app_loads do
    require "merb_inspector" / "inspectors" / "data_mapper" if defined?(DataMapper)

    class Merb::Controller
#      include Merb::Inspector::Helper
    end
  end
  
  Merb::Plugins.add_rakefiles "merb_inspector/merbtasks"
end
