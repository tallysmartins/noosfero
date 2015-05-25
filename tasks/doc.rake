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

desc 'Publishes PDF'
task :pdfupload => :pdf do
  require 'date'

  tag = Date.today.strftime('doc-%Y-%m-%d-') + $SPB_ENV
  blob = `git hash-object -w docs/_build/latex/softwarepublico.pdf`.strip
  tree = `printf '100644 blob #{blob}\tsoftwarepublico-#{$SPB_ENV}.pdf\n' | git mktree`.strip
  commit = `git commit-tree -m #{tag} #{tree}`.strip

  sh 'git', 'tag', tag, commit
  sh 'git', 'push', 'origin', tag
end

desc 'Removes generated files'
task :clean do
  sh 'make -C docs/ clean'
end
