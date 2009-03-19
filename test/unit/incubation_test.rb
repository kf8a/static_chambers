require File.dirname(__FILE__) + '/../test_helper'

class IncubationTest < ActiveSupport::TestCase
  fixtures :incubations

  def setup
    @incubation = Incubation.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Incubation,  @incubation
  end
end
