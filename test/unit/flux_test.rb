require File.dirname(__FILE__) + '/../test_helper'

class FluxTest < ActiveSupport::TestCase
  fixtures :fluxes

  def setup
    @flux = Flux.find(1)
  end

  # Replace this with your real tests.
  def test_read
    assert_kind_of Flux,  @flux
  end
end
