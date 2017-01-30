const ajaxAction = (query, action) => {
  return $.ajax({
    type: "PUT",
    url: `/searches/${action}`,
    contentType: "application/json",
    data: JSON.stringify({ query })
  });
}

export const ajaxIncrement = query => {
  ajaxAction(query, 'increment').done(response => {
    console.log(response);
  });
}

export const ajaxDecrement = query => {
  ajaxAction(query, 'decrement').done(response => {
    console.log(response);
  });
}
