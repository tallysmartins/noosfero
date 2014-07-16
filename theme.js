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
 //insere a mensagem na página de registro//
  $( ".action-account-signup #content form" ).prepend( "<div class='singup_text'><p>Registre-se. Crie sua conta no Participa Brasil! Este é mais um espaço de diálogo entre governo e sociedade civil. Depois que você se registrar será possível fazer comentários e/ou contribuições, participar de consultas públicas, criar blogs, participar e/ou criar comunidades, etc.</p><p>A gestão pública nunca esteve tão próxima das pessoas como agora. Faça parte desta mudança!</p><p>Seja bem vind@!</p></div>" );
  //Alinha os blocos do tipo container lado a lado      
  $('.container-block-plugin_container-block').each(alignBlocks);

  $('#block-48500 > .block-inner-1 > .block-inner-2').append('<div class="more_button" style="position: absolute; top: 5px; left: 519px;"><div class="view_all"><a href="/portal/blog">Ler todas</a></div></div>');

})(jQuery);
