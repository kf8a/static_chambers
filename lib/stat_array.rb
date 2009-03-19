require 'arrayx' # separate post

# Statistical methods for arrays. Also see NArray Ruby library.

class Float

  def roundf(decimel_places)
      temp = self.to_s.length
      sprintf("%#{temp}.#{decimel_places}f",self).to_f
  end

end

class Integer

  # For easy reading e.g. 10000 -> 10,000 or 1000000 -> 100,000
  # Call with argument to specify delimiter.

  def ts(delimiter=',')
    st = self.to_s.reverse
    r = ""
    max = if st[-1].chr == '-'
      st.size - 1
    else
      st.size
    end
    if st.to_i == st.to_f
      1.upto(st.size) {|i| r << st[i-1].chr ; r << delimiter if i%3 == 0 and i < max}
    else
      start = nil
      1.upto(st.size) {|i|
        r << st[i-1].chr
        start = 0 if r[-1].chr == '.' and not start
        if start
          r << delimiter if start % 3 == 0 and start != 0  and i < max
          start += 1
        end
      }
    end
    r.reverse
  end

end

class Array

  def sum
    inject( nil ) { |sum,x| sum ? sum+x : x }
  end

  def mean
    sum=0
    self.each {|v| sum += v}
    sum/self.size.to_f
  end

  def variance
    m = self.mean
    sum = 0.0
    self.each {|v| sum += (v-m)**2 }
    sum/self.size
  end

  def stdev
    Math.sqrt(self.variance)
  end

  def count                                 # => Returns a hash of objects and their frequencies within array.
    k=Hash.new(0)
    self.each {|x| k[x]+=1 }
    k
  end
    
  def ^(other)                              # => Given two arrays a and b, a^b returns a new array of objects *not* found in the union of both.
    (self | other) - (self & other)
  end

  def freq(x)                               # => Returns the frequency of x within array.
    h = self.count
    h(x)
  end

  def maxcount                              # => Returns highest count of any object within array.
    h = self.count
    x = h.values.max
  end

  def mincount                              # => Returns lowest count of any object within array.
    h = self.count
    x = h.values.min
  end

  def outliers(x)                           # => Returns a new array of object(s) with x highest count(s) within array.
    h = self.count                                                              
    min = self.count.values.uniq.sort.reverse.first(x).min
    h.delete_if { |x,y| y < min }.keys.sort
  end

  def zscore(value)                         # => Standard deviations of value from mean of dataset.
    (value - mean) / stdev
  end

end
