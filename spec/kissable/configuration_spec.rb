require 'spec_helper'

describe Kissable::Configuration do
  let(:configuration) { described_class.new }

  describe "#logger=" do
    it "can be set" do
      configuration.logger = "SimpleLogger"
      expect(configuration.logger).to eq("SimpleLogger")
    end
  end
end