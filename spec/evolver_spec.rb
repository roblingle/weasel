require File.join(File.dirname(__FILE__), 'spec_helper.rb')

context Evolver do
  
  before do
    @eve = Evolver.new("protozoa")
  end
  
  context "with default options" do
    it "should have a value for all options" do
      @eve.options.each{|key,value| value.should_not be_nil }
    end
  end
  
  context "with custom options" do
    
    before do
      @eve = Evolver.new("protozoa", { :target => 'monkey', 
                                       :offspring => 20, 
                                       :length_penalty => 100,  
                                       :spelling_multiplier => 2
                                      })
    end
    
    it "options should be set from the options hash" do
      @eve.options[:target].should == 'monkey'
      @eve.options[:offspring].should == 20
      @eve.options[:length_penalty].should == 100
      @eve.options[:spelling_multiplier].should == 2
    end
    
  end
  
  context "when calculating fitness" do
    
    before do
      @eve = Evolver.new("thing", { :target => "thong!" })
    end
    
    it "should not break when longer than the target" do
      @eve.options[:target] = "t"
      lambda{ @eve.fitness }.should_not raise_error
    end
    
    it "should correctly calculate the spelling penalty" do
      @eve.should_receive(:length_penalty).and_return(0)  # ignore length penalty
      @eve.fitness.should == -6 # 0 - (?i - ?o).abs
    end
    
    it "should correctly calculate the length penalty" do
      @eve.should_receive(:spelling_penalty).and_return(0) # ignore length penalty
      @eve.fitness.should == -25 # ("thing!".size - "thong".size).abs * 25
    end
    
  end
  
  context "when procreating" do
    
    before do
      @eve = Evolver.new("protozoa", { :target => "monkey" })
      @eve.procreate!(2)
    end
    
    it "should create the requested number of offspring" do
      @eve.children.size.should == 2
      
      @eve.procreate!(100)
      @eve.children.size.should == 100
    end
    
    it "should pass on the target to offspring" do
      @eve.children.each{ |child| child.options[:target].should == @eve.options[:target] }
    end
    
    it "should increment the generation number" do
      @eve.children.each{ |child| child.generation.should == @eve.generation + 1 }
    end
    
  end
  
  context "when mutating" do
    
    it "should change length the randomly determined amount" 
    
  end
  
  context "when judging fitness among offspring" do
    
    before do
      @eve.options[:target] = "protozoa"
      @eve.children = %w( orotozoa zoaprota abracadabra ).map{ |c| Evolver.new(c, @eve.options) }
    end
    
    it "should check each offspring" do
      @eve.children.each{ |child| child.should_receive(:fitness).at_least(:once).and_return(-100) }
      @eve.select_fittest
    end
    
    it "should return a single evolver" do
      fittest = @eve.select_fittest
      fittest.class.should == Evolver
    end
    
    it "should return the fittest" do
      @eve.select_fittest.should == "orotozoa"
    end
    
  end
  
end
