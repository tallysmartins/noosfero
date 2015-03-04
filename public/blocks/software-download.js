modulejs.define('SoftwareDownload', ['jquery'], function($) {
  'use strict';

  var $download_html_template;

  function getDownloadListTemplate() {
    var block_template = sessionStorage.getItem('download_list_block_template');

    if(block_template && block_template.length > 0) {
      $download_html_template = block_template;
    } else {
      $.get('/plugin/software_communities/get_block_template', function(response) {
        $download_html_template = response;
        sessionStorage.setItem('download_list_block_template', response);
      });
    }
  }


  function SoftwareDownload() {
    getDownloadListTemplate();
  }


  SoftwareDownload.prototype.addNewDonwload = function() {
    var new_download = $($download_html_template);
    $("#droppable-list-downloads").append(new_download);
  }


  SoftwareDownload.prototype.deleteDownload = function(element) {
    var delete_download = $(element).parent().parent().parent().remove();
  }


  return {
    isCurrentPage: function() {
      return $('.download-block').length !== 0;
    },


    init: function() {
      window.softwareDownload = new SoftwareDownload();
    }
  }
});
