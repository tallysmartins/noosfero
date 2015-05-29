require 'yaml'

$SPB_ENV = ENV.fetch('SPB_ENV', 'local')

$_.gsub!('@@SPB_ENV@@', $SPB_ENV)

config = YAML.load_file("../config/#{$SPB_ENV}/config.yaml")
config.each do |key,value|
  $_.gsub!("@@#{key}@@", value.to_s)
end

$_.gsub!(/@@config\(([^\)]*)\)@@/) do |f|
  lines = File.read("../config/#{$SPB_ENV}/#{$1}").lines
  lines.shift + lines.map do |line|
    '    ' + line
  end.join
end
