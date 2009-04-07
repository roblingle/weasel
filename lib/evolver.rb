class Evolver < String
  attr_accessor :parent, :generation, :children, :options
  
  def initialize( initial, options = {} )

    @options = {
      :target               => "Methinks it is like a weasel",
      :offspring            => 100,
      :length_penalty       => 25,
      :spelling_multiplier  => 1,
      :spelling_mutations   => 2,
      :length_mutations     => 2,
      :allow_clones         => true
    }.merge(options)
    
    # must have some mutations allowed:
    if @options[:spelling_mutations].nil? or @options[:spelling_mutations] < 2
      @options[:spelling_mutations] = 2 # rand(2) returns 0 or 1
    end
    if @options[:length_mutations].nil? or @options[:length_mutations] < 2
      @options[:length_mutations] = 2
    end
    
    @generation = 1
    @children   = []
    super(initial)
  end
  
  # Be fruitful! Multiply! Have offspring that are slightly 
  # mutated versions of yourself, who will be imperceptibly 
  # more or less fit than you were! 
  def procreate!( offspring = @options[:offspring] )
    @children = []
    offspring.times{ @children << mutant_offspring }
    @children.reject!{ |child| child.to_s == to_s } unless @options[:allow_clones]
    @children
  end
  
  # Find the most fit among the offspring
  def select_fittest
    @children.max{ |this,that| this.fitness <=> that.fitness }
  end
  
  # Measure fitness relative to the target string.
  # 0 represents ideal fitness- i.e. no unfitness. 
  def fitness
    0 - length_penalty - spelling_penalty
  end
  
  protected
  
    # Create a mutant version of the instance.
    def mutant_offspring
      offspring = Evolver.new(self.to_s, @options)
      offspring.parent = self
      offspring.generation = self.generation+1
      
      offspring.mutate_length
      offspring.mutate_spelling
    end
    
    # Change the length of the string. With a length_mutation of 3,
    # the size of the string may be changed by -3 to +3 characters.
    # When growing, random characters are appended, when shrinking,
    # positions are dropped off of the end.
    def mutate_length
      original = self.to_s
      length_change = rand_between_plus_and_minus(@options[:length_mutations])
      if length_change > 0
        length_change.times{ self << random_char}
      elsif length_change < 0
        range = size + length_change
        range = 0 if range < 0 # not letting strings become empty
        slice!(0,range)
      end
      self
    end
    
    # Change the spelling of the string. With a spelling_mutation of 3,
    # the spelling of the string is changed in between 0 and 3 places.
    # For each spelling mutation, the string will be changed in a random
    # position to a random character.
    def mutate_spelling
      spelling_changes = rand(@options[:spelling_mutations]+1)
      spelling_changes.times{ self[rand(size)] = random_char }
      self
    end
  
    # Finds the difference between the evolver and the target and 
    # multiply by the length penalty. A penalty of 94 treats the
    # difference between number of characters the same as the 
    # greatest possible spelling penalty, i.e. ("~"[0]-" "[0])*diff
    def length_penalty
      (@options[:target].size - self.size).abs * @options[:length_penalty]
    end
  
    # Adds up the absolute differences of each char in the evolver 
    # from each char in the target. 
    #
    # Increasing the multiplier from the default of 1 drastically
    # increases the pressure to spell the string correctly.
    def spelling_penalty
      chars.inject_with_index(0) do |penalty, char, i| 
        if i < @options[:target].size
          # add to penalty the differences between ascii values in the two strongs * the multiplier
          penalty + ((@options[:target][i] - char[0]).abs * @options[:spelling_multiplier])
        else
          penalty # evolver string is longer than the target, return penalty unchanged.
        end
      end
    end
    
    # returns a random ascii character between SPACE and ~
    def random_char
      lower=32
      upper=126
      (rand(upper-lower+1) + lower).chr
    end
    
    # Generates a random integer between +/- the specified number 
    def rand_between_plus_and_minus(number)
      rand(number*2) - number
    end

end