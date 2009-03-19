require File.dirname(__FILE__) + '/../test_helper'

class StandardTest < ActiveSupport::TestCase
  fixtures :standards

  def setup
    @standard = Standard.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Standard,  @standard
  end
end
