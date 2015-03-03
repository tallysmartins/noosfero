(function($) {
  'use strict';

  function add_new_link(){
    var newDownload = $(window.download_list_template);
    newDownload.attr('data-counter-id', 1);
    $("#droppable-list-downloads").append(newDownload);
  }


  function delete_link(add_element){
    var deleteDownload = $(add_element).parent().parent().parent();
    deleteDownload.remove();
  }


  function get_download_list_template() {
    var blockTemplate = JSON.parse(sessionStorage.getItem('download_list_block_template'));

    if(blockTemplate) {
      window.download_list_template = blockTemplate;
    } else {
      $.get('/plugin/software_communities/get_block_template', function(response) {
        window.download_list_template = response;
        sessionStorage.setItem('download_list_block_template', response);
      });
    }
  }

  $(document).ready(function() {
    window.add_new_link = add_new_link;
    window.delete_link = delete_link;

    if( window.download_list_template === undefined ) {
      get_download_list_template();
    }
  });
})(jQuery);
