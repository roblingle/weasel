require File.join(File.dirname(__FILE__), 'inject_with_index.rb')
require File.join(File.dirname(__FILE__), 'evolver.rb')

class Weasel
  attr_accessor :selected,:random
  
  def initialize(initial = 'protozoa', options = {})
    @selected = Evolver.new(initial)
    @random   = Evolver.new(initial)
  end
  
  # The 'selected' and 'random' evolvers both create random offspring.
  # The selection process makes all the difference.
  def generation
    @selected.procreate!
    @random.procreate!
    
    # select the fittest mutant offspring
    @selected = @selected.select_fittest
    # select a random mutant offspring
    @random   = @selected.children[rand(@selected.children.size)]
  end
  
end