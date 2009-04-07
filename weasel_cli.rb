require File.join(File.dirname(__FILE__), 'lib', 'weasel.rb')

options = {
  :target               => "Methinks it is like a weasel",
  :offspring            => 100,
  :length_penalty       => 5,
  :spelling_multiplier  => 5,
  :spelling_mutations   => 2,
  :length_mutations     => 2,
  :allow_clones         => true
}

@weasel = Weasel.new("protozoa",options)
puts @weasel.selected
while @weasel.selected.fitness != 0 do
  @weasel.generation
  puts "Current: " + @weasel.selected
  puts "Score: #{@weasel.selected.fitness}"
  puts "Generation: #{@weasel.selected.generation}"
  puts "Parent: " + @weasel.selected.parent
  puts 
  puts "Random: #{@weasel.random}"
  puts "Score: #{@weasel.random.fitness}"
  puts
end
  
