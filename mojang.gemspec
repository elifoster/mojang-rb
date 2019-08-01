Gem::Specification.new do |s|
  s.authors = ['Eli Foster']
  s.name = 'mojang'
  s.summary = 'Mojang and Minecraft web APIs in Ruby'
  s.version = '1.0.3'
  s.license = 'MIT'
  s.description = 'A Ruby library accessing the Mojang and Minecraft web APIs'
  s.email = 'elifosterwy@gmail.com'
  s.homepage = 'https://github.com/elifoster/mojang-rb'
  s.metadata = {
    'issue_tracker' => 'https://github.com/elifoster/mojang-rb/issues'
  }
  s.files = [
    'lib/errors.rb',
    'lib/mojang.rb',
    'LICENSE.md'
  ]
  s.add_runtime_dependency('curb', '~> 0.9')
  s.add_runtime_dependency('oj', '~> 3.8')
end 
