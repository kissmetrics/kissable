require 'spec_helper'

describe Kissable::SinatraCookieAdapter do
  let(:response)  { double('response') }
  let(:request)   { double('request') }
  let(:name)      { 'name' }
  let(:value)     { 'value' }
  subject(:cookie_adapter) { Kissable::SinatraCookieAdapter.new(request, response) }

  describe "#initialize" do
    it { should respond_to(:request) }
    it { should respond_to(:response) }
  end

  describe "#[]" do
    it "calls request.cookies with cookie_name" do
      request.should_receive(:cookies).and_return({})
      cookie_adapter[name]
    end

    it "returns the stored value" do
      request.stub(:cookies).and_return({name => value})
      expect(cookie_adapter[name]).to eq(value)
    end
  end

  describe "#[]=" do
    it "calls set_cookie on response" do
      response.should_receive(:set_cookie).with(name, value)
      cookie_adapter[name] = value
    end
  end
end