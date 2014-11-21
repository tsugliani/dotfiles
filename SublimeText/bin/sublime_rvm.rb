#!/usr/bin/env ruby

file = File.expand_path(ARGV[0] || (STDERR.puts('you must specify a ruby file'); exit(-1)))
dir = File.dirname file
while dir.size > 1
  if File.exist?(dir + '/.rvmrc')
    to_exec = "source \"$HOME/.rvm/scripts/rvm\";cd #{dir}; ruby #{file}"
    #puts to_exec
    exec(to_exec)
  else
    dir = dir.sub(/\/[^\/]*$/, '')
  end
end

puts "Could not find any .rvmrc above #{file}"
exit(-1)

