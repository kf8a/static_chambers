require File.dirname(__FILE__) + '/../test_helper'

class CalibrationTest < ActiveSupport::TestCase
  fixtures :calibrations
  
  def setup
    @calibration = Calibration.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Calibration,  @calibration
  end
end
