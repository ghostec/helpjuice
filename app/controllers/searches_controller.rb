class SearchesController < ApplicationController
  def search
    @queries = Query.all.order(count: :desc)
  end

  def increment
    perform(:increment_count)
  end

  def decrement
    perform(:decrement_count)
  end

  def clean
    Query.delete_all
    render json: { status: 200 }
  end

  private

  def perform(action)
    QueryWorker.perform_async(search_normalized, QueryWorker::ACTIONS[action])
    render json: { status: 200 }
  end

  def search_normalized
    params[:query][:search].downcase
  end
end
