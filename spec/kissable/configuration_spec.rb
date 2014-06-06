require 'spec_helper'

describe Kissable::Configuration do
  subject(:configuration) { described_class.new }

  it { should respond_to(:logger) }
  it { should respond_to(:domain) }

  describe "#logger" do
    it "defaults to Logger" do
      expect(configuration.logger.class).to eq(Logger)
    end
  end

  describe "#domain" do
    it "defaults to nil" do
      expect(configuration.domain).to eq(nil)
    end
  end

  context "when Logger is written to" do
    it "doesn't have an error" do
      expect(Kissable.configuration.logger.info("test")).to_not raise_error
    end
  end
end