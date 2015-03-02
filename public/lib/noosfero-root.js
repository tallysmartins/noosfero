modulejs.define('NoosferoRoot', function() {
  function url_with_subdirectory(url) {
    return noosfero_root() + url;
  }

  return {
    urlWithSubDirectory: url_with_subdirectory
  }
});
