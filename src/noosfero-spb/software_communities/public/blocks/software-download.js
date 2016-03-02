modulejs.define('SoftwareDownload', ['jquery', 'NoosferoRoot'], function($, NoosferoRoot) {
  'use strict';

  function SoftwareDownload() {
  }

  SoftwareDownload.prototype.addNewDonwload = function() {
    var new_download = $('#download-list-item-template').html();
    $("#droppable-list-downloads").append(new_download);
  }

  SoftwareDownload.prototype.selectFile = function(element) {
    var path = $(element).find('.file-path').val();
    var size = $(element).find('.file-size').html();

    var download_option = $(element).find('.file-size').closest('.download-option');
    download_option.find('#block_downloads__link').val(path);
    download_option.find('#block_downloads__size').val(size);

    var fileElements = $(element).parent().parent().find('.file-item');
    for (var i = 0; i < fileElements.length; i++) {
      fileElements[i].classList.remove('selected');
    }
    $(element).parent()[0].classList.add('selected');
  }

  SoftwareDownload.prototype.toggleForm = function(element) {
    var files_ul = $(element).parent().find('.toggle-form')[0];
    files_ul.classList.toggle('opened');
    files_ul.classList.toggle('closed');
  }

  SoftwareDownload.prototype.deleteDownload = function(element) {
    var delete_download = $(element).closest('.download-option').remove();
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
