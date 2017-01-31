require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe "#increment" do
    describe "new query" do
      it "normalizes before saving" do
        put :increment, params: { query: { search: 'How to cancel subscription' } }
        query = Query.find_by(search: 'how to cancel subscription')
        expect(query.search).to eq('how to cancel subscription')
        expect(query.count).to eq(1)
      end
    end

    describe "persisted query" do
      let(:query) { Query.create(search: 'How to cancel subscription') }

      before { query }

      it "increments" do
        put :increment, params: { query: { search: 'How to cancel subscription' } }
        query = Query.find_by(search: 'how to cancel subscription')
        expect(query.search).to eq('how to cancel subscription')
        expect(query.count).to eq(2)
      end
    end
  end

  describe "#decrement" do
    describe "count > 1" do
      let(:query) { Query.create(search: 'How to cancel subscription') }

      before { query.increment_count }

      it "decrements by 1" do
        put :decrement, params: { query: { search: 'How to cancel subscription' } }
        query = Query.find_by(search: 'how to cancel subscription')
        expect(query.search).to eq('how to cancel subscription')
        expect(query.count).to eq(1)
      end
    end

    describe "count == 1" do
      let(:query) { Query.create(search: 'How to cancel subscription') }

      before { query }

      it "destroys empty count query" do
        put :decrement, params: { query: { search: 'How to cancel subscription' } }
        query = Query.find_by(search: 'how to cancel subscription')
        expect(query).to eq(nil)
      end
    end
  end

  describe "#clean" do
    let(:query) { Query.create(search: 'string') }

    before { query }

    it { expect{get :clean}.to change{Query.count}.from(1).to(0) }
  end
end
