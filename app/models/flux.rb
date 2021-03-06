require 'gsl'

class Array

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
  
  def stderr
    stdev/Math.sqrt(self.size)
  end
end

class Flux < ActiveRecord::Base #CachedModel 
  has_many :samples, :dependent => :destroy
  belongs_to :compound
  belongs_to :incubation
  
  NaN = (0.0/0.0)
  
  def flux
    c0, c1 = fit
    f = c1 * headspace/surface_area * 100 * 1440 / 22.4 * compound.mol_weight #carbon or nitrogen 
    unless f.nan?
      self.flux=f
    else
      self.flux = nil
    end
    self.save
    
    return f
  end
  
  def comment
    samples.collect {|x| x.comment }.uniq.join(' ')
  end
  
  def headspace
    return NaN unless incubation.lid
    
    if 'Z' == incubation.lid.name
      # compute gas bucket volume 
      # divide by 1000 to convert from cm^3 to liters
      return (Math::PI * (((26 + 0.094697)/2)**2) * (incubation.avg_height_cm - 1))/1000 # one cm from the top of the bucket to the mark
    else
      begin
        if incubation.avg_height_cm.nil?
          incubation.avg_height_cm = 19.5
        end
        ((incubation.avg_height_cm-(incubation.lid.height-1)) * 745)/1000 + self.incubation.lid.volume
      rescue NoMethodError
        return NaN
      end
    end
  end
  
  def surface_area 
    return NaN unless incubation.lid
    if 'Z' == incubation.lid.name
      return Math::PI * (((26 + 0.094697)/2)**2)
    else
      return 745
    end
  end
  
  def m
    m = case 
      when compound.name == 'co2' then 0.04 #0.035
      when compound.name == 'ch4' then 27
      when compound.name == 'n2o' then 170
    end
    return m
  end
  
  def toggle_point(seconds)
    samples.find_by_seconds(seconds).toggle!('excluded')
  end
  
  def maxy 
    max = case 
      when compound.name == 'co2' then 4000
      when compound.name == 'ch4' then 6
      when compound.name == 'n2o' then 1 #0.7
    end
    return max
  end
  
  def miny
     0
  end
  
  def minx
    0
  end
  
  def maxx
    samples.collect {|x| x.seconds}.compact.max + 10
  end
  
  def x_scale
    250 / maxx
  end
  
  def chisq(multiplier=1)
    c0, c1, cov00, cov01, cov11, chisq, status = linear_fit(multiplier) unless x_nil?
    chisq
  end
  
  def r2(multiplier=1)
    unless x_nil?
      c0, c1, cov00, cov01, cov11, chisq, status = linear_fit(multiplier)
      n = self.samples.size
      return chisq/(n * cov11)
    end
    return 0
  end
  
  def fit(multiplier=1)
      c0, c1, cov00, cov01, cov11, chisq, status = linear_fit(multiplier)
      return [c0,c1]
  end
  
  def plot
    f= File.dirname(__FILE__) + "/../../tmp/flux_" + self.id.to_s + ".png"
    r = samples.collect {|s| s.excluded ? [nil,nil,nil] : [s.seconds, s.ppm, s.id]}
    
    other_incubations = Incubation.find_all_by_run_id_and_treatment(self.incubation.run, self.incubation.treatment)

    other_fluxes = other_incubations.collect do | i |
      Flux.find(:all, :conditions=>['incubation_id  = ? and compound_id = ?', i.id, self.compound_id])
    end
    other_fluxes.flatten!
    other_fluxes.compact!
  
    o = other_fluxes.collect do |of|
      of.samples.collect {|s| s.ppm} unless of.samples.any? {|x| x.ppm.nil? }
    end
    o.compact!
    
    means = o.transpose.collect do |s|
      [s.mean,s.stderr]
    end

    means = [r] + [means]
    p means
    p means.transpose.collect {|x| x.join("\t")}
    title = "#{self.id.to_s}__#{self.incubation.run.name.gsub(/ /,'_')}_run_#{self.incubation.run_id}_trt#{self.incubation.treatment}__rep#{self.incubation.replicate}"
    IO.popen("/usr/local/bin/pl -png -o #{f} -prefab scat title=#{title}   ylbl='ppm' xlbl='minutes' data=- x=1 y=2 id=3 x2=1 y2=4 err2=5  corr=yes idcolor=black delim=tab", 'w') {|p| p << means.transpose.collect {|x| x.join("\t")}.join("\n")
    }

  end
  
private 
  def linear_fit(multiplier)
    x = samples.collect {|a| a.seconds unless a.excluded || a.seconds.nil?}.compact
    y = samples.collect {|a| a.ppm * multiplier unless a.excluded || a.ppm.nil?}.compact
    if x.size > 0 && y.size > 0
      x = GSL::Vector.alloc(x) 
      y = GSL::Vector.alloc(y)
      return GSL::Fit.linear(x, y)
    end
    return [(0.0/0.0), (0.0/0.0)]  #NaN
  end
  
  def x_nil?
    self.samples.collect {|a| a.ppm}.include?(nil)
  end
end
