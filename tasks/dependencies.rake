task :check_dependencies do
  missing = [
    { program: 'sphinx-build', package: 'python-sphinx' },
    { program: 'make', package: 'make' },
  ].select do |dependency|
    !system("which #{dependency[:program]} >/dev/null")
  end
  missing.each do |dependency|
    puts "Please install package #{dependency[:package]}"
  end
  fail 'E: missing dependencies' if missing.size > 0
end
