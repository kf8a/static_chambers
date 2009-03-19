require File.dirname(__FILE__) + '/../test_helper'

require 'compound'

class CompoundTest < ActiveSupport::TestCase
  fixtures :compounds

  def setup
    @compound = Compound.find(1)
  end

  def test_read
    assert_kind_of Compound,  @compound
    assert_equal 3, Compound.count
    assert_not_nil compounds(:methane)
    assert_equal compounds(:methane).name, Compound.find(3).name
    assert_not_nil compounds(:nitrous_oxide)
    assert_equal compounds(:nitrous_oxide).name, Compound.find(2).name
    assert_not_nil compounds(:carbon_dioxide)
    assert_equal compounds(:carbon_dioxide).name, Compound.find(1).name
  end
end
