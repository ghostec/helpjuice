require 'rails_helper'

RSpec.describe QueryWorker, type: :worker do
  describe "#perform" do
    let(:query) { Query.create(search: 'string') }

    before { query }

    it "increments query.count" do
      QueryWorker.perform_async(query.search, QueryWorker::ACTIONS[:increment_count])
      expect(query.reload.count).to eq(2)
    end

    it "decrements query.count == 2" do
      query.increment_count
      QueryWorker.perform_async(query.search, QueryWorker::ACTIONS[:decrement_count])
      expect(query.reload.count).to eq(1)
    end

    it "decrements query.count == 1" do
      QueryWorker.perform_async(query.search, QueryWorker::ACTIONS[:decrement_count])
      expect{query.reload}.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
