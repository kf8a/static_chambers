require 'gsl'

class Curve < ActiveRecord::Base
  belongs_to :calibration
  belongs_to :compound
  has_many :standards, :dependent => :delete_all
  
  def maxx
    unless x_nil?
      return standards.collect {|x| x.ppm }.max 
    end
    0
  end
  
  def maxy
    standards.collect {|x| x.response }.max
  end
  
  def minx
    unless x_nil?
      return standards.collect {|x| x.ppm}.min
    end
    0
  end
  
  def miny
    standards.collect {|x| x.response}.min
  end
  
  def r2
    unless x_nil?
      c0, c1, cov00, cov01, cov11, chisq, status = linear_fit
      n = self.standard.size
      return chisq/(n * cov11)
    end
    return 0
  end
  
  def fit(divisor=1)
    unless x_nil?
      c0, c1, cov00, cov01, cov11, chisq, status = linear_fit(divisor)
      return [c0,c1]
    end
    return[0,0]
  end

  def x_nil?
    standards.collect {|a| a.ppm}.include?(nil)
  end

  private 
    def linear_fit(divisor)
      x = Vector.alloc(standards.collect {|a| a.ppm}) 
      y = Vector.alloc(standards.collect {|a| a.response/divisor})
      return Fit.linear(x, y)
    end
end
