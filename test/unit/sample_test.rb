require File.dirname(__FILE__) + '/../test_helper'

class SampleTest < ActiveSupport::TestCase
  fixtures :samples

  def setup
    @sample = Sample.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Sample,  @sample
  end
end
