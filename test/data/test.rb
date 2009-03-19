require 'csv'
string = File.read('setup2004-9.csv')
arr = CSV.parse(string)
p arr.shift
