require 'rails_helper'

describe 'searcing' do
  it "doesn't save while still typing", js: true do
    visit '/'
    fill_in 'query', with: 'How'
    sleep(1)
    fill_in 'query', with: 'How to'
    sleep(1)
    fill_in 'query', with: 'How to cancel'
    sleep(3)
    expect(Query.count).to eq(1)
    expect(Query.last.search).to eq('how to cancel')
    expect(Query.last.count).to eq(1)
  end

  it "removes prefix searches within keepingInterval", js: true do
    visit '/'
    fill_in 'query', with: 'How to cancel'
    sleep(3)
    expect(Query.count).to eq(1)
    expect(Query.last.search).to eq('how to cancel')
    expect(Query.last.count).to eq(1)

    fill_in 'query', with: 'How to cancel subscription'
    sleep(3)
    expect(Query.count).to eq(1)
    expect(Query.last.search).to eq('how to cancel subscription')
    expect(Query.last.count).to eq(1)
  end

  it "doesn't remove prefix searches if past keepingInterval", js: true do
    visit '/'
    fill_in 'query', with: 'How to cancel'
    sleep(3)
    expect(Query.count).to eq(1)
    expect(Query.last.search).to eq('how to cancel')
    expect(Query.last.count).to eq(1)

    first_query = Query.last

    sleep(21)

    fill_in 'query', with: 'How to cancel subscription'
    sleep(3)
    expect(Query.count).to eq(2)
    expect(Query.last.search).to eq('how to cancel subscription')
    expect(Query.last.count).to eq(1)
    expect(Query.find_by(search: 'how to cancel')).to eq(first_query)
  end
end
