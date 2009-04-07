require File.join(File.dirname(__FILE__), 'lib', 'weasel.rb')

@weasel = Weasel.new
puts @weasel.selected
while @weasel.selected.fitness != 0 do
  @weasel.generation
  puts "Generation: #{@weasel.selected.generation}"
  puts "Parent: " + @weasel.selected.parent
  puts "Current: " + @weasel.selected
  puts 
  puts "Random: #{@weasel.random}"
  puts
end
  
