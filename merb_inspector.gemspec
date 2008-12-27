Gem::Specification.new do |s|
  s.name = "merb_inspector"
  s.version = "0.1"
  s.date = "2008-12-27"
  s.summary = ""
  s.email = "maiha@wota.jp"
  s.homepage = "http://github.com/maiha/merb_inspector"
  s.description = ""
  s.has_rdoc = true
  s.authors = ["maiha"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/merb_inspector.rb", "lib/merb_inspector/helper.rb", "lib/merb_inspector/inspector.rb", "lib/merb_inspector/inspectors/base.rb", "lib/merb_inspector/inspectors/data_mapper.rb", "lib/merb_inspector/merbtasks.rb", "mirror/public/stylesheets/merb_inspector.css", "spec/merb_inspector_spec.rb", "spec/spec_helper.rb", "templates/data_mapper/collection/_records.html.erb", "templates/data_mapper/resource/_edit.html.erb", "templates/data_mapper/resource/_new.html.erb", "templates/data_mapper/resource/_record.html.erb", "templates/data_mapper/resource/_show.html.erb", "test/merb_inspector_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<merb-core>, [">= 1.0.7"])
    else
      s.add_dependency(%q<merb-core>, [">= 1.0.7"])
    end
  else
    s.add_dependency(%q<merb-core>, [">= 1.0.7"])
  end
end
