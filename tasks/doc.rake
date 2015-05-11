desc 'Builds documentation'
task :doc do
  sh 'make -C docs/ html'
end

desc 'Removes generated files'
task :clean do
  sh 'make -C docs/ clean'
end
