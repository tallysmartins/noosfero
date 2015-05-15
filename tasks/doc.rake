desc 'Builds documentation (HTML)'
task :doc do
  sh 'make -C docs/ html'
end

desc 'Builds documentation (PDF)'
task :pdf do
  sh 'make -C docs/ latexpdf'
end

desc 'Opens PDF documentation'
task :viewpdf => :pdf do
  sh 'xdg-open', 'docs/_build/latex/softwarepublico.pdf'
end

desc 'Removes generated files'
task :clean do
  sh 'make -C docs/ clean'
end
