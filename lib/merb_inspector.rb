# make sure we're running inside Merb
if defined?(Merb::Plugins)

  $: << File.dirname(__FILE__) unless $:.include?(File.dirname(__FILE__))
  
  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  Merb::Plugins.config[:merb_inspector] = {
    :chickens => false
  }
  
  Merb::BootLoader.before_app_loads do
    # require code that must be loaded before the application
  end
  
  Merb::BootLoader.after_app_loads do
    inspector_dir = File.dirname(__FILE__) / "../inspectors"

    require "merb_inspector" / "inspector"
    require "merb_inspector" / "manager"
    require "merb_inspector" / "helper"

    Dir["#{inspector_dir}/*.rb"].sort.each do |file|
      begin
        require file
      rescue Exeption  => error
        message = "[MerbInspector] load error: #{error} (#{error.class})"
        Merb.logger.error message
      end
    end

    class ::Application
      include Merb::Inspector::Helper
    end

    Merb::Inspector::Manager.install
  end
  
  Merb::Plugins.add_rakefiles "merb_inspector/merbtasks"
end
