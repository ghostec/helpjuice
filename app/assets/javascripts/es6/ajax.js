const ajaxAction = (query, action) => {
  return $.ajax({
    type: "PUT",
    url: `/searches/${action}`,
    contentType: "application/json",
    data: JSON.stringify({ query })
  });
}

const genId = query => {
  return `query-${query.search.replace(/\s/g, '--')}`;
}

const sumToQueryCount = (query, value) => {
  const $query = $(`#${genId(query)}`);
  const $query_count = $query.find('query-count');
  const count = parseInt($query_count.html());

  if(count + value == 0) $query.remove();
  else $query_count.html(count + value);

  return $query_count;
}

export const ajaxIncrement = query => {
  ajaxAction(query, 'increment').done(response => {
    if(sumToQueryCount(query, 1).length > 0) return;
    $('queries').append(`<query id="${genId(query)}">
                        <query-search>${query.search}</query-search>
                        <query-count>1</query-count>
                        </query>`);
  });
}

export const ajaxDecrement = query => {
  ajaxAction(query, 'decrement').done(response => {
    sumToQueryCount(query, -1);
  });
}
