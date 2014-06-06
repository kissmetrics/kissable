require 'spec_helper'

describe Kissable do
  let(:test_name) { 'some-test' }

  describe ".tracking_script" do
    let(:identity) { double('identity', :name => test_name, :id => 'Original') }

    it "returns an embeddable script" do
      expect(described_class.tracking_script(identity)).to match(/^<script>.*<\/script>$/)
    end

    it "contains the _kmq push event" do
      expect(described_class.tracking_script(identity)).to include("_kmq.push")
    end

    it "sets the property to the id passed" do
      expect(described_class.tracking_script(identity)).to include("['set', {'#{test_name}' : 'Original'}]")
    end
  end

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

