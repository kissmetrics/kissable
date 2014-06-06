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
end

