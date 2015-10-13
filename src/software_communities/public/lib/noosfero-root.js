modulejs.define('NoosferoRoot', function() {
  'use strict';


  function url_with_subdirectory(url) {
    return noosfero_root() + url;
  }


  return {
    urlWithSubDirectory: url_with_subdirectory
  }
});
