require File.dirname(__FILE__) + '/../test_helper'

class RunTest < ActiveSupport::TestCase

  def generate_plots
    # Generate Plots 
    treatments =  (1..8).to_a
    1.upto(8) do  |treatment|
      1.upto(6) do |replicate|
        Factory(:plot, :treatment => treatment, :replicate => replicate, 
        :name => "T#{treatment}R#{replicate}")
      end
    end
  end
  
  def generate_compound
    Factory(:compound, :name => 'co2')
    Factory(:compound, :name => 'ch4')
    Factory(:compound, :name => 'n2o')
  end

  context "after loading a setup file" do
    setup do 
      @run = Run.new

      generate_plots
      generate_compound

      file_name = File.dirname(__FILE__)+'/../data/lter2004-4.csv'
      @run.setup=File.read(file_name)
    end

    should "have some incubations" do
      assert @run.incubations.count > 0
    end

    should "an incubation with a positive volume" do
      assert @run.incubations.find(:first).volume > 0
    end

    should "have an incubation in T1R1" do
      plot = Plot.find_by_name('T1R1')
      assert @run.incubations.find_by_plot_id(plot)
    end

    should "have an incubation with 4 samples" do
      assert @run.incubations.find(:first).samples.count == 4
    end

    should "have 29 incubations" do
      assert @run.incubations.count == 29
    end

    should "have 137 Samples" do
      assert @run.samples.count == 137
    end
    
    should "have a sample with vial id == 1" do
      sample = @run.samples.find_by_vial(1)
      assert sample != nil
    end
    
    context "after adding a measurement file" do
      setup do
        file_name = File.dirname(__FILE__)+'/../data/lter2006-series5.csv'
        @run.data=File.read(file_name)

        @sample = @run.incubations.find(:first).samples[0]
      end

      should "have measurements for a sample" do
        assert  @sample.measurements.count > 0
      end

      should "have 3 measurements for a sample" do
        assert @sample.measurements.count  == 3
      end

      context "measurements" do
        setup do
          @measurement = @sample.measurements[0]
        end

        should "have a positive ppm measurement" do
          assert @measurement.ppm > 0
        end

      end

    end

  end

end
