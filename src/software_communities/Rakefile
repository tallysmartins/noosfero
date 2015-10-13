task :default => :makemo

task :makemo do
  require 'gettext'
  require 'gettext/tools'
  GetText.create_mofiles(
    verbose: true,
    po_root: 'po',
    mo_root: 'locale',
  )
end
