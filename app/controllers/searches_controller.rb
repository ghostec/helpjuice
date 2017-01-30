class SearchesController < ApplicationController
  def search
  end

  def increment
    search_str = params[:query][:search].downcase
    query = Query.find_or_initialize_by(search: search_normalized)
    query.increment_count if query.persisted? else query.save
    render json: json(query)
  end

  def decrement
    query = Query.find_by(search: search_normalized)
    (return render json: { errors: [ "Search term not found" ] }) if query.nil?
    query.decrement_count
    render json: json(query)
  end

  private

  def json(query)
    {
      search: query.search,
      count: query.count
    }
  end

  def search_normalized
    params[:query][:search].downcase
  end

  def query_params
    params.require(:query).permit(:search)
  end
end
