import  { ajaxIncrement, ajaxDecrement } from './ajax';
import { typingInterval, keepingInterval } from './constants';

$(document).on('turbolinks:load', () => {
  let queries = [];

  const removeOldQueries = () => {
    const time = new Date().getTime();
    queries = queries.filter((query) => {
      return (time - query.saved_at.getTime()) < keepingInterval;
    });
  }

  const removePrefixQueries = new_query => {
    queries = queries.filter((query) => {
      const isPrefix = new_query.search.startsWith(query.search);
      if(isPrefix) ajaxDecrement(query); // decrement/destroy on data store
      return !isPrefix;
    });
  }

  const saveQuery = query => {
    if(query.search.replace(/\s/g, '').length == 0) return; // only spaces

    removeOldQueries();
    removePrefixQueries(query);

    queries.push(query);

    ajaxIncrement(query); // increment on data store
  }

  $('#query').on('keyup', () => {
    const elem = $('#query');
    const val = elem.val();

    setTimeout(() => {
      const curval = elem.val();
      const last_query = queries[queries.length - 1];
      const last_search = last_query && last_query.search;

      // while typing or backspacing from already saved query
      if(val != curval || val == last_search) return;

      saveQuery({
        search: val,
        saved_at: new Date()
      });
    }, typingInterval);
  });
});
