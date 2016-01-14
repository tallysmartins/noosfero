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
    e.defaultPrevented();
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

  //toggle filter options in catalog page
  function setFilterCategoriesOptionClass() {
    var filterOptions = $("#filter-categories-option");
    filterOptions.addClass("animated slideInDown");
  }

  function toggleFilterOptions(){
    var filterOptions = $("#filter-categories-option");
    var filterHeight = filterOptions[0].scrollHeight;
    var showOptions = $("#filter-option-catalog-software");
    var hideOptions = $("#filter-option-catalog-close");
    if(hideOptions.is(":visible")){
      //filterOptions.slideUp(function() {
        showOptions.show();
        hideOptions.hide();
      //});
      filterOptions.animate({
        height: 0
      },500);
    }
    else {
      showOptions.hide();
      hideOptions.show();
      filterOptions.animate({
        height: filterHeight
      },500);
    }
  }

  function setEvents(){
    // Fade css
    $('.software-block-finality').css('opacity', 0);
    $('.software-block-finality').css('top', 0);
    // End Fade CSS
    $(".software-block").mouseover(show_finality);
    $(".software-block").mouseout(hide_finality);

    var showOptions = $("#filter-option-catalog-software");
    var hideOptions = $("#filter-option-catalog-close");
    showOptions.click(toggleFilterOptions);
    hideOptions.click(toggleFilterOptions);
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
    var additional_data_bar = $('.comments-display-fields');

    additional_data_bar.on('click', function() {
      var arrow = additional_data_bar.find('span[class*="comments-arrow"]');
      var additional_fields = $('.comments-software-extra-fields');

      if (additional_fields) {
        animateExtraFields(additional_fields, arrow);
      }
    });
  }


  function animateExtraFields(additional_fields, arrow) {
    var innerHeight = additional_fields[0].offsetHeight;

    if(additional_fields.height() !== 0) {
      arrow.attr('class', "comments-arrow-down");
      additional_fields.animate({height: 0});
    } else {
      arrow.attr('class', "comments-arrow-up");
      additional_fields.animate({height: additional_fields.get(0).scrollHeight}, 1000 );
    }

    // Fix for the arrow change on modal display to block, killing the entire page
    $("#institution_modal").css({'display':'none'});
  }


  function set_use_report_content() {
    $('.profile-homepage .organization-average-rating-container .rate-this-organization a').html('Avalie este software');
    $('.make-report-block .make-report-container .button-bar a span').html('Avalie este software');
    $('.star-rate-data .star-rate-form.rating-cooldown .button-bar a span').html('Avalie este software');
    $('.make-report-block .make-report-container .make-report-message').html('Relate sua experiência ou do órgão/empresa com relação ao software.');
    $('.ratings-list .see-more a.icon-arrow-right-p').html('veja todos os relatos');
    $('.main-content .star-rate-data .star-rate-form .star-comment-container .button-bar input').attr('value', 'Enviar');
    $('.main-content .star-rate-data .star-rate-form .star-rate-text').html('Avalie este software');
    $('.main-content .star-rate-data .star-rate-form .star-comment-container .formlabel').html('Depoimento sobre o software');
    $('.star-rate-form .star-comment-container .comments-display-fields span#comments-additional-information').html('Dados adicionais (órgãos e empresas)');
    $('.star-rate-form .star-comment-container .comments-software-extra-fields #input_institution_comments label').html('Nome do órgão ou empresa');
    $('.star-rate-form .star-comment-container .comments-software-extra-fields .comments-software-people-benefited label').html('Número de beneficiados');
    $('.star-rate-form .star-comment-container .comments-software-extra-fields .comments-software-saved-values label').html('Recursos economizados');
  }

  function add_tooltips(){
    $('#content span[title]').attr("data-toggle","tooltip");

    $('[data-toggle="tooltip"]').tooltip();
  }

  function add_popovers() {
    var span = $('span[data-toggle="popover"]');
    var place = span.attr("data-placement");
    var elementClass = span.attr("data-class");
    if(span){
      var popover =  span.popover({
        html:true,
        placement: place,
        content: function() {
          return $(this).next().html();
        }
      })
      .data('bs.popover');
    }
    if(popover) {
      popover.tip()
      .addClass(elementClass);
      $('a.toggle-popover').on("click",function() {
        span.trigger("click");
      });
    }
  }

  function move_breadcrumbs() {
    $('.breadcrumbs-plugin_content-breadcrumbs-block').prependTo('#wrap-2');
    $('<span id="breadcrumbs-you-are-here">Você está aqui:</span>').insertBefore($('.breadcrumbs-plugin_content-breadcrumbs-block .block-inner-2').children().first());
  }

  // temporary solution for the suspension_point in some buttons
  function remove_suspension_points_in_buttons() {
    $(".template-kind a span:contains('...')").each(function(index, element) {
      element.innerHTML = element.innerHTML.replace(/(\...)/, "");
    });
  }

  // temporary solution for the text in send_email buttons
  function replace_send_email_button_text() {
    $('.action-profile-members .page-members-header .icon-menu-mail').html('Contatar administradores');
  }

  $(document).ready(function(){
    add_tooltips();
    add_popovers();
    move_article_buttons();
    move_breadcrumbs();
    insert_notice_div();
    set_uploaded_files_names();
    set_tooltip_content();
    set_arrow_direction();
    set_use_report_content();
    setEvents();
    remove_suspension_points_in_buttons();
    replace_send_email_button_text();
    });
})(jQuery);
