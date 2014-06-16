require 'spec_helper'

describe Kissable do
  let(:test_name) { 'some-test' }

  describe ".configure" do
    let(:data) { '123' }

    it "sets the configuration" do
      Kissable.configure do |config|
        config.domain = data
      end

      expect(Kissable.configuration.domain).to eq(data)
    end
  end
end

