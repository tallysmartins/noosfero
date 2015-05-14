$SPB_ENV = ENV.fetch('SPB_ENV', 'local')

$_.gsub!('@@SPB_ENV@@', $SPB_ENV)

$_.gsub!(/@@config\(([^\)]*)\)@@/) do |f|
  lines = File.read("../config/#{$SPB_ENV}/#{$1}").lines
  lines.shift + lines.map do |line|
    '    ' + line
  end.join
end
