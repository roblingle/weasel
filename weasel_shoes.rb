require File.join(File.dirname(__FILE__), 'lib', 'weasel.rb')

Shoes.app do
  debug String.new.respond_to? :chars
  
  stack :margin => 5 do
  
    flow do
      para 'Generation:'
      @generation_field = para(0)
    end
    
    flow do
      para 'Parent:'
      @parent_field = para(nil)
    end
    
    flow do
      para 'Current:'
      @current_field = para(nil)
    end
    
  end
  
  debug "starting on #{RUBY_VERSION}"
  @weasel = Weasel.new
  debug 'created a weasel'
  
  while @weasel.selected.fitness != 0 do
    @weasel.generation
    debug @weasel.selected.generation
        
    #@generation_field.replace para(@weasel.selected.generation)
    #@parent_field.replace para(@weasel.selected.parent)
    #@current_field.replace para(@weasel.selected)
  
  end
  
end