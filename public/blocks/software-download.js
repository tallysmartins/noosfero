modulejs.define('SoftwareDownload', ['jquery', 'NoosferoRoot'], function($, NoosferoRoot) {
  'use strict';

  var AJAX_URL = {
    get_download_template:
      NoosferoRoot.urlWithSubDirectory("/plugin/software_communities/get_block_template")
  };

  var $download_html_template;

  function getDownloadListTemplate() {
    var block_template = sessionStorage.getItem('download_list_block_template');

    if(block_template && block_template.length > 0) {
      $download_html_template = block_template;
    } else {
      $.get(AJAX_URL.get_download_template, function(response) {
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
