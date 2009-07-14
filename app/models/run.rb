require 'csv'

class Run < ActiveRecord::Base
  has_many :calibrations, :dependent => :destroy
  has_many :incubations, :dependent => :destroy
  has_many :samples, :dependent => :destroy
  
  belongs_to :group
  
  def number_of_points
    p = samples.collect do |x| 
      x.ppm
    end
    [p.flatten.size,p.flatten.compact.size]
  end
  
  def data=(file_contents)
    reader = CSV.parse(file_contents)
    reader.each do | data |
      # set test to an empty string in case a cell in column a is empty
      test = data[0] || ''
      do_sample(data) if test.strip.downcase == "sample"
      do_standard(data) if test.strip.downcase == "standard"
    end
    self.save
  end
    
  def setup=(file_contents)
    p file_contents
    reader = CSV.parse(file_contents)
    self.name = reader.shift[0]
    reader.shift
    reader.shift
    self.sampled_on = reader.shift[0]
    reader.shift
    self.save
    reader.each do | row |
      next if row[0].nil?
      p [row[0], row[1],row[2]]
      incubation = incubations.find_by_treatment_and_replicate_and_chamber(row[0],row[1], row[2])
      p incubation
      if incubation.nil?
        incubation = Incubation.new
        incubation.treatment = row[0]
        incubation.replicate = row[1]
        incubation.chamber = row[2]
        incubation.lid = Lid.find_by_name(row[5])

        incubation.avg_height_cm = (row[6].to_f+row[7].to_f+row[8].to_f+row[9].to_f)/4
        incubation.soil_temperature = row[10]
        
        self.incubations << incubation
        incubation.save
      end
      # create a flux and samples for each compound
      compounds = Compound.find(:all)
      compounds.each do |compound|
        sample = Sample.new
        flux = incubation.fluxes.find_by_compound_id(compound.id)
        if flux.nil?
          flux = Flux.new
          flux.compound = compound
          incubation.fluxes << flux
        end
        sample.minutes =  row[14] unless row[14].nil?
        sample.comment = row[COMMENT[compound.name]]
        sample.vial = row[4]
        sample.compound = compound
        sample.run = self
        flux.samples << sample
      end
      self.save
    end
  end
  
  private
  COMMENT = {'n2o' => 16, 'co2' => 19, 'ch4' => 22}
  PPM = { 'n2o' => 11, 'co2' => 12, 'ch4' => 13 }
  RESPONSE = { 'n2o' => 2, 'co2' => 4, 'ch4' => 6 }
  
  def do_sample(data)
    Compound.find(:all).each do |compound|
      sample = samples.find_by_vial_and_compound_id(data[1].to_i, compound.id)
      unless sample.nil?
        sample.response = data[RESPONSE[compound.name]]
        sample.ppm = data[PPM[compound.name]]
        sample.excluded = true if sample.ppm < 0
        sample.save
      end
    end
  end
  
  def do_standard(data)
    Compound.find(:all).each do |compound|
      standard = Standard.new
      standard.ppm = data[PPM[compound.name]]
      standard.response = data[RESPONSE[compound.name]]
      
      calibration = calibrations.find_by_name(data[1])
      if calibration.nil?
        calibration = Calibration.new(:name => data[1])
        calibrations << calibration
        calibration.save
      end
      curve = calibration.curves.find_by_compound_id(compound.id)
      if curve.nil?
        curve = Curve.new(:compound => compound)
        calibration.curves << curve
      end
      curve.standards << standard
    end
  end
  
  def load_sample(elements)
    sample = Sample.new
    components = Compound.find_all();
    components.each do | compound |

      # create an entry in the sample and in the flux table
      sample = Sample.new

      sample.minutes = elements[2]
      sample.response = elements[RESPONSE[compound.name]]
      sample.ppm = elements[PPM[compound.name]]

      # find our incubation with the right name in the current run
      incubation = incubations.find_by_name(elements[1].downcase)

      # if we don't have an incubation create a new one
      if incubation.nil?
        incubation = Incubation.new
        incubation.name = elements[1]

        self.incubations << incubation
      end

      incubation.save

      #find a flux and create it if necessary
      flux = incubation.fluxes.find_by_compound_id(compound.id)
      if flux.nil?
        flux = Flux.new
        flux.compound = compound
        #flux.save

        incubation.fluxes << flux
      end

      flux.samples << sample      
    end

  end

  def load_standard(elements)
    compounds = Compound.find_all();
    
    compounds.each do | compound |

      standard = Standard.new
      standard.ppm = elements[PPM[compound.name]]
      standard.response = elements[RESPONSE[compound.name]]
      
      calibration = calibrations.find_by_name(elements[1])

      if calibration.nil?
        calibration = Calibration.new
        calibration.name = elements[1]
        #calibration.save

        self.calibrations << calibration
      end

      calibration.save
      
      curve = calibration.curves.find_by_compound_id(compound.id)
      if curve.nil?
        curve = Curve.new
        curve.compound = compound
        
        calibration.curves << curve
      end
      
      curve.standards << standard
    end
  end
end
