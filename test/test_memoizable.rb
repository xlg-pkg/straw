# frozen_string_literal: true

require "test_helper"

class Item
  include ::Straw::Memoizable

  attr_reader :calls

  def initialize
    @calls = Hash.new { |h, k| h[k] = 0 }
  end

  def value(item)
    memoize(:value) do
      @calls[:value] += 1
      item
    end
  end
end

describe ::Straw::Memoizable do
  def setup
    @subject = Item.new
  end

  describe "#memoize" do
    describe "when the result has not been memoized" do
      it "computes the result only once" do
        instance = Object.new
        2.times { _(@subject.value(instance)).must_equal instance }

        _(@subject.calls[:value]).must_equal 1
      end

      it "caches a nil value to prevent duplicate calls" do
        2.times { assert_nil(@subject.value(nil)) }

        _(@subject.calls[:value]).must_equal 1
      end

      it "caches a false value to prevent duplicate calls" do
        2.times { _(@subject.value(false)).must_equal false }

        _(@subject.calls[:value]).must_equal 1
      end
    end
  end
end
