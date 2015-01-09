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

  $(document).ready(function(){
    set_events();
    });
})(jQuery);
