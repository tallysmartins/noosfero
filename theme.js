function alignBlocks(containerIndex){
    //Needed to save the original reference to jQuery(this)
    jt = jQuery(this);
    longerBlock = 0;
    jt.find(".block-outer").each(function () {
        if(jQuery(this).height() > longerBlock)
                longerBlock = jQuery(this).height();
    });

    jt.find("#block-48504 .block-inner-2").height(492);
    jt.find("#block-55304 .block-inner-2").height(378);

    //Aligns the blocks in the most common situations
    jt.find(".block-outer").height(longerBlock);
    //Only used for blocks with video, since it uses the size of the iframe
    if(jt.find("iframe").length > 0){
        jt.find(".block-inner-1 .block-inner-2").each(function (idx) {
            if(idx==2){
                 jQuery(this).height(jt.find("iframe").height());
             }
        });
    }
}

(function($) {
  // Run code
	if($.cookie("high_contrast") === 'true'){
		$( "body" ).toggleClass( "contraste" );
	}
	$( "#siteaction-contraste a" ).click(function() {
		$( "body" ).toggleClass( "contraste" );
		if($('body').hasClass('contraste')){
			$.cookie('high_contrast', 'true', {path: '/'});
		} else {
			$.cookie('high_contrast', null, { path: '/' });
		}
	});

  $( ".profile-image" ).prepend( "<span class='helper'></span>" );
  //insere a mensagem no bloco de trilhas na página inicial//
  $( ".action-home-index #content .community-track-plugin_track-card-list-block .track_list" ).prepend( "<span class='msg_block'>Construa seu caminho de participação na elaboração de políticas públicas...</span>" );
  //insere a mensagem no bloco de comunidades na página inicial//
  $( ".action-home-index #content .communities-block .block-inner-2>div" ).prepend( "<span class='msg_block'>Participe dos dialogos entre governo e sociedade em comunidades temáticas...</span>" );
  $( ".action-home-index #content .communities-block .block-inner-2>div.block-footer-content .msg_block" ).remove();
  $('.container-block-plugin_container-block').each(alignBlocks);

  $('#block-48500 > .block-inner-1 > .block-inner-2').append('<div class="more_button" style="position: absolute; top: 5px; left: 519px;"><div class="view_all"><a href="/portal/blog">Ler todas</a></div></div>');



// Foco no botao de busca

$('#link-buscar').click(function(e) {
    e.preventDefault();
    window.location.hash = '#portal-searchbox';
    $('.searchField').focus()
})

})(jQuery);


// Efeito Fade nos box de softwares

(function($){
  "use strict";// Make javascript less intolerant to errors

  var TRANSITION_TIME = 250;// milliseconds


  function show_finality() {
    var finality = $(this).children(".software-block-finality");

    //finality.stop().fadeTo(TRANSITION_TIME,1);
    finality.stop().fadeTo('fast', 1);
    //finality.stop().animate({"top" : "0%"}, TRANSITION_TIME);
  }

  function hide_finality() {
    var finality = $(this).children(".software-block-finality");

    //finality.stop().fadeTo(TRANSITION_TIME,0);
    finality.stop().fadeTo('fast', 0);
    //finality.stop().animate({"top" : "100%"}, TRANSITION_TIME);
  }

  function set_events() {
    // Fade css
    $('.software-block-finality').css('opacity', 0);
    $('.software-block-finality').css('top', 0);
    // End Fade CSS

    $(".software-block").mouseover(show_finality);
    $(".software-block").mouseout(hide_finality);
  }

  function move_article_buttons(){
    var article_actions = $('#article-actions').clone();
    var report = $('.report-abuse-action').remove();
    var suggest = $('.icon-suggest').remove();


    $(article_actions).find('.icon-edit, .icon-new, .icon-delete, .icon-locale').remove();
    $('.article-body').append(article_actions);
  }

  function add_link_to_article_div(){
    var list = $('.display-content-block').find('li');

    list.each(function(){
      var link = $(this).find('.title').find('a').attr('href');
      var text = $(this).find('.lead').find('p').text();
      var leadLink = $('<a></a>');

      leadLink.attr('href', link);
      leadLink.text(text);

      $(this).find('.lead').html(leadLink);
    });
  }

  function insert_notice_div(){
    var notice = $('.display-content-block').find('li');
      notice.each(function(){
        var $set = $(this).children();
        for(var i=1, len = $set.length; i < len; i+=5){
          $set.slice(i, i+5).wrapAll('<div class="notice-item"/>');
        }
        for(var i=2, len = $set.length; i < len; i+=3){
          $set.slice(i, i+3).wrapAll('<div class="notice-info"/>');
        }
      //$('<div class="notice-item"></div>').wrap($(this).find( '.image', '.title', '.lead', '.read_more'));
    });


  }

  /* Finds all uploaded files from manuals page and sets its names on the right format */
  function set_uploaded_files_names() {
   try {
      var article = document.getElementById('article');
      var folderList = article.getElementsByClassName('folder-content')[0];
      var folderItens = folderList.getElementsByClassName('item-description');

      for(var i = 0; i < folderItens.length; i++) {
        split_file_extension(folderItens[i].getElementsByTagName('a')[0]);
      }
    } catch(e) {

    }
  }

  /* Splits a file name from its extension. Example: example.pdf becomes example - PDF */
  function split_file_extension(element) {
    var tokens = element.innerHTML.split('.');
    if(tokens.length == 2) {
      var fileName = tokens[0];
      var fileExtension = tokens[1].toUpperCase();
      element.innerHTML = fileName + " - " + fileExtension;
    }
  }

  function set_tooltip_content() {
    $('.star-tooltip').html("?");
  }

  function set_arrow_direction() {
    var additional_data_bar = $('#comments-additional-information');
    var arrow = $('.comments-arrow-down');
    var state = 0;

    additional_data_bar.on('click', function() {
      if(state === 0) {
        arrow.attr('class', "comments-arrow-up")
        state = 1;
      } else {
        state = 0;
        arrow.attr('class', "comments-arrow-down");
      }
    });
  }

  function set_use_report_content() {
    $('.make-report-block .make-report-container .button-bar a span').html('avaliar o software');
    $('.make-report-block .make-report-container .make-report-message').html('Relate sua experiência ou do órgão/empresa com relação ao software.');
    $('.ratings-list .see-more a.icon-arrow-right-p').html('veja todos os relatos');
  }

  function add_top_tooltips(){
    $('#content span[title]').attr("data-toggle","tooltip");

    $('[data-toggle="tooltip"]').tooltip({
        position: {
            my: "top-82",
            at: "center"
        },
        tooltipClass: "ui-tooltip-top"
    });
  }

  function add_bottom_tooltips(){
    $('#content span[title]').attr("data-toggle","tooltip");

    $('[data-toggle="tooltip"]').tooltip({
        position: {
            my: "bottom+82",
            at: "center"
        },
        tooltipClass: "ui-tooltip-bottom"
    });
  }

  $(document).ready(function(){
    add_top_tooltips();
    set_events();
    move_article_buttons();
    add_link_to_article_div();
    insert_notice_div();
    set_uploaded_files_names();
    set_tooltip_content();
    set_arrow_direction();
    set_use_report_content();
    });
})(jQuery);
