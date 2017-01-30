require 'rails_helper'

RSpec.describe Query, type: :model do
  describe "new query" do
    it "normalizes before saving" do
      query = Query.new(search: 'String With CAPS')
      query.save
      expect(query.search).to eq('string with caps')
      expect(query.count).to eq(1)
    end
  end

  describe "updating query" do
    let(:query) { Query.create(search: 'How to cancel subscription') }

    it "increments count" do
      expect(query.count).to eq(1)
      expect(query.search).to eq('how to cancel subscription')

      query.increment_count
      
      expect(query.count).to eq(2)
      expect(query.search).to eq('how to cancel subscription')
    end
  end

  describe "#decrement_count" do
    describe "count > 1" do
      let(:query) { Query.create(search: 'string') }

      before { query.increment_count }

      it { expect{query.decrement_count}.to change{query.count}.by(-1) }
    end

    describe "count == 1" do
      let(:query) { Query.create(search: 'string') }

      before { query }

      it { expect{query.decrement_count}.to change{Query.count}.by(-1) }
    end
  end
end
