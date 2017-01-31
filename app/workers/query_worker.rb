class QueryWorker
  include Sidekiq::Worker

  ACTIONS = { increment_count: 'increment_count', decrement_count: 'decrement_count' }.freeze

  def perform(search, action)
    query = Query.find_or_initialize_by(search: search.downcase)
    query.send(action) if query.persisted? else (query.save unless query.destroyed?)
  end
end
