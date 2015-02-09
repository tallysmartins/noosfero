if !File.exist?('.ssh_config')
  sh "vagrant ssh-config > .ssh_config"
end

require 'chake'

task :test do
  Dir.glob('test/*_test.sh').each do |t|
    sh 'sh', t
  end
end

task :default => :test
