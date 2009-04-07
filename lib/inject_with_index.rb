unless String.instance_methods.include? 'chars'
  class String
    def chars
      c = []
      0..size do |i|
        c << self[i].chr
      end
      c
    end
  end
end

module Enumerable
  def inject_with_index(injected)
    each_with_index{|obj, index| injected = yield(injected, obj, index) }
    injected
  end
end