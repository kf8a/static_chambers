require 'rubygems'
require 'hpricot'

print "<html><body>"
Dir.glob("./tmp/*.png") do |i|
  print "<img src='#{i}' height='400' width='400'/>"
end
print "</body></html>"