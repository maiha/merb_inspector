# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{merb_inspector}
  s.version = "0.2.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Maiha"]
  s.date = %q{2008-12-30}
  s.description = %q{Merb plugin that provides powerful 'inspect' helper method}
  s.email = %q{maiha@wota.jp}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/merb_inspector", "lib/merb_inspector/helper.rb", "lib/merb_inspector/merbtasks.rb", "lib/merb_inspector/manager.rb", "lib/merb_inspector/inspector.rb", "lib/merb_inspector.rb", "spec/spec_helper.rb", "spec/merb_inspector_spec.rb", "inspectors/object.rb", "inspectors/hash.rb", "inspectors/basic.rb", "inspectors/data_mapper.rb", "inspectors/array.rb", "templates/hash", "templates/hash/_default.html.erb", "templates/_default.html.erb", "templates/basic", "templates/basic/_default.html.erb", "templates/array", "templates/array/_default.html.erb", "templates/object", "templates/object/_plain.html.erb", "templates/object/_default.html.erb", "templates/data_mapper", "templates/data_mapper/resource", "templates/data_mapper/resource/_record.html.erb", "templates/data_mapper/collection", "templates/data_mapper/collection/_records.html.erb", "mirror/public", "mirror/public/stylesheets", "mirror/public/stylesheets/merb_inspector.css"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/maiha/merb_inspector}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{merb}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Merb plugin that provides powerful 'inspect' helper method}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<merb>, [">= 1.0.7"])
    else
      s.add_dependency(%q<merb>, [">= 1.0.7"])
    end
  else
    s.add_dependency(%q<merb>, [">= 1.0.7"])
  end
end
