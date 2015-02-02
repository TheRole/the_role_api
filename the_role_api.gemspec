# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "the_role_api/version"

Gem::Specification.new do |s|
  s.name        = "the_role_api"
  s.version     = TheRoleApi::VERSION
  s.authors     = ["Ilya N. Zykin [the-teacher]"]
  s.email       = ["zykin-ilya@ya.ru"]
  s.homepage    = "https://github.com/TheRole/the_role_api"
  s.summary     = %q{Authorization for Rails 4}
  s.description = %q{Authorization for Rails 4 with Web Interface}

  s.files         = `git ls-files`.split("\n").select{ |file_name| !(file_name =~ /^spec/) }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]


  s.add_dependency 'multi_json'
  s.add_dependency 'the_string_to_slug', '~> 1.2'
  s.add_runtime_dependency 'rails', ['>= 3.2', '< 5']
end
