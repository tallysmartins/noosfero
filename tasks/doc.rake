desc 'Builds documentation'
task :doc do
  sh 'make -C docs/ html'
end
