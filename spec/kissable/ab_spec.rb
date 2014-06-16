require 'spec_helper'

describe Kissable::AB do
  let(:test_name) { "sample_test" }
  let(:groups) { nil }
  let(:ratios) { nil }
  let(:cookies) { {} }
  let(:ab_test) { described_class.new(test_name, groups, ratios) }

  describe '#initialize' do
    context "when initialized" do
      context "with no groups" do
        it "assigns an Original group" do
          expect(ab_test.groups).to include("Original")
        end

        it "assigns a Variant group" do
          expect(ab_test.groups).to include("Variant")
        end
      end

      context "with one group" do
        let(:groups) { ["one"] }

        it "raises an error" do
          expect{ ab_test }.to raise_error(ArgumentError, 'A minimium of two groups are required')
        end
      end

      context "with five groups" do
        let(:groups) { ["one", "two", "three", "four", "five"] }

        it "raises an error" do
          expect{ ab_test }.to raise_error(ArgumentError, "The max number of split groups is 4")
        end
      end

      context "when ratio is nil" do
        it "sets the ratios evenly" do
          expect(ab_test.ratios).to eq([50.0, 50.0])
        end
      end

      context "with a mismatch of ratios to groups" do
        let(:ratios) { [100] }
        let(:groups) { ["one", "two"] }

        it "raises an error" do
          expect{ab_test}.to raise_error(ArgumentError, "Mismatch with groups and ratios")
        end
      end

      context "when ratios don't add up to 100" do
        let(:ratios) { [90, 5] }
        let(:groups) { ["one", "two"] }

        it "raises an error" do
          expect{ab_test}.to raise_error(ArgumentError, "ABHelper ratios sum to 95 not 100")
        end
      end
    end
  end

  describe '#group' do
    let(:group) { ab_test.group(cookies) }

    xit "is a struct" do
      expect(group).to be_a(Struct)
    end

    describe "name" do
      xit "is the test_name" do
        expect(group.name).to eq(test_name)
      end
    end

    it "is returns Original or Variant" do
      expect(group).to match(/Original|Variant/)
    end


    context "when cookie exists" do
      before :each do
        ab_test.stub(:cookies).and_return({'abid' => 1})
      end

      it "doesn't change the cookie" do
        expect{group}.to_not change{ab_test.cookies}
      end
    end

    context "when cookie doesn't exist" do
      it "sets a cookie" do
        expect{group}.to change{ab_test.cookies}.from({})
      end

      describe "the cookie" do
        let(:cookie) { ab_test.cookies['abid'] }

        context "when the domain has been configured" do
          let(:domain) { 'someaweseomedomain.com' }

          it "has the domain key set to the correct value" do
            Kissable.configure do |config|
              config.domain = domain
            end

            group
            expect(cookie).to include(:domain => domain)
          end
        end

        context "when the domain hasn't been configured" do
          it "doesn't include a domain key" do
            Kissable.configure do |config|
              config.domain = nil
            end

            group
            expect(cookie).to_not include(:domain)
          end
        end

        it "expires" do
          group
          expect(cookie).to include(:expires)
        end

        it "has a path" do
          group
          expect(cookie).to include(:path => "/")
        end

        it "contains a value" do
          group
          expect(cookie).to include(:value)
        end
      end
    end
  end

  describe "#tracking_script" do
    let(:group) { 'Original' }

    it "returns an embeddable script" do
      expect(ab_test.tracking_script(group)).to match(/^<script>.*<\/script>$/)
    end

    it "contains the _kmq push event" do
      expect(ab_test.tracking_script(group)).to include("_kmq.push")
    end

    it "sets the property to the id passed" do
      expect(ab_test.tracking_script(group)).to include("['set', {'#{test_name}' : 'Original'}]")
    end
  end
end