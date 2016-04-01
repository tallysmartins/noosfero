/* globals jQuery */

// Theme namespace
var SPBNoosferoTheme = {};

// Add in jQuery a method that executes a given function only if there is a filled query result
jQuery.fn.doOnce = function( func ) {
    this.length && func.apply( this );
    return this;
}

// Animate Organization Ratings additional informations form
SPBNoosferoTheme.OrganizationRatings = (function($) {
  'use strict';

  // Add a question mark next to each form field, so when user mouse over it,
  // it displays some userfull information about the field
  function setTooltipContent() {
    $('span.star-tooltip').html('?');
  }

  // Given the current state of the form(hidden or in display)
  // change the arrow image and animte its state change
  function animateExtraFields(additionalFields, arrow) {
    var innerHeight = additionalFields[0].offsetHeight;

    // If in display, puts the down arrow and hide the form
    if(additionalFields.height() !== 0) {
      arrow.attr('class', 'comments-arrow-down');
      additionalFields.animate({height: 0});
    } else { // if the form is hidden, puts the up arrow and display the form
      arrow.attr('class', 'comments-arrow-up');
      additionalFields.animate({
        height: additionalFields.get(0).scrollHeight
      }, 1000 );
    }

    // Fix for the arrow change on the additional informations, it prevents the institution modal
    // from killing the entire page. When the form had their status changed, the institution modal
    // tended to cover the page even if it was not in display
    document.getElementById('institution_modal').style.display = 'none';
  }

  // Set additional informations form up and down arrows click event
  function setArrowDirection() {
    var reportForm = $('div.star-comment-container');
    var parent = reportForm.parent();
    reportForm.detach(); // Remove form from the page DOM

    // Apply arrows click event
    var additionalDataBar = reportForm.find('div.comments-display-fields');
    additionalDataBar.on('click', function() {
      var arrow = additionalDataBar.find('span[class*="comments-arrow"]');
      var additionalFields = reportForm.find('.comments-software-extra-fields');
      animateExtraFields(additionalFields, arrow);
    });

    // Add the form back to the page
    parent.append(reportForm);
  }


  function initialize() {
    $('div.star-rate-form').doOnce(function() {
        setTooltipContent();
        setArrowDirection();
    });
   }

  return {
    init: initialize
  };

}) (jQuery);

// Fade effect on software blocks of portal homepage
SPBNoosferoTheme.HighlightedSoftwaresBlock = (function($) {
  'use strict';

  function showFinality() {
    var finality = $(this).children('div.software-block-finality');
    finality.stop().fadeTo('fast', 1);
  }

  function hideFinality() {
    var finality = $(this).children('div.software-block-finality');
    finality.stop().fadeTo('fast', 0);
  }

  // Set the mouse over and out event in each of the finality blocks in the page
  function setFadeInOutFinality(){
    $('#boxes div.software-block-finality').css({'opacity':0, 'top':0});
    var softwaresBlocks = $('#boxes div.software-block');

    softwaresBlocks.mouseover(showFinality);
    softwaresBlocks.mouseout(hideFinality);
  }

  function initialize() {
    $('#boxes .box-1 div.software-communities-plugin_softwares-block').doOnce(function() {
      setFadeInOutFinality();
    });
  }

  return {
    init: initialize
  };
}) (jQuery);


SPBNoosferoTheme.NoosferoHTMLAdjusts = (function($) {
  'use strict';

  // Take each list item from the block and apply to its lead the same link as its title
  // then wraps the list item inside a new div with class notice-item
  function insertLinksAndWrapsOnHomeNews(){
    var news = $('div.display-content-block').find('li');
    var parent = news.parent();
    news.detach();
    news.each(function(){
      //add link on lead
      var link = $(this).find('div.title a').attr('href');
      var lead = $(this).find('div.lead');
      var leadLink = $('<a></a>');

      leadLink.attr('href', link);
      leadLink.text(lead.find('p').text());
      lead.html(leadLink);

      //add wraps to improve styling
      $(this).find('div:gt(0)').wrapAll('<div class="notice-item"/>');
      $(this).find('.notice-item div:gt(0)').wrapAll('<div class="notice-info"/>');
    });

    parent.append(news);
  }

  // Add a toggle tooltip to all span with title attribute
  function addTooltips(){
    $('#content span[title]').doOnce(function(){
      this.attr('data-toggle', 'tooltip');
      this.tooltip();
    });
  }

  // Make the link next to a popover span show the popover when it is clicked
  function addPopovers() {
    var span = $('span[data-toggle="popover"]');
    var place = span.attr('data-placement');
    var elementClass = span.attr('data-class');

    span.doOnce(function(){
      var popover =  this.popover({
        html:true,
        placement: place,
        content: function() {
          return $(this).next().html();
        }
      })
      .data('bs.popover');

      if(popover) {
        popover.tip()
        .addClass(elementClass);

        // Make the link show the span popover when it is clicked
        $('a.toggle-popover').on('click',function() {
          span.trigger('click');
        });
      }
    });
  }

  function moveBreadcrumbs() {
    $('div.breadcrumbs-plugin_content-breadcrumbs-block').doOnce(function() {
      this.insertBefore('#content-inner');
      $('<span id="breadcrumbs-you-are-here">Você está aqui:</span>').insertBefore(this.find('div.block-inner-2').children().first());
    });
  }

  function removeButtons(){
    $('#article-actions').doOnce(function() {
      $(this).children('.icon-spread, .icon-locale, .report-abuse-action, .icon-clone').remove();
    });

    $('div.page-members-header').doOnce(function() {
      $(this).find('.report-abuse-action').remove();
    });
  }

  // Put the focus on the search form when user click on the "go to search link"
  function searchLinkApplyFocusToItsForm() {
    $('#link-buscar').click(function(e) {
      e.defaultPrevented();
      $('.searchField').focus();
    });
  }

  function initialize() {
    insertLinksAndWrapsOnHomeNews();
    addTooltips();
    addPopovers();
    moveBreadcrumbs();
    searchLinkApplyFocusToItsForm();
    removeButtons();
  }

  return {
    init: initialize
  };

}) (jQuery);

// Software catalog category filter toggle functionality
SPBNoosferoTheme.SoftwareCatalog = (function($) {
  'use strict';

  // Apply the toggle animation on the category filter based on its current status
  function toggleFilterOptions(){
    var filter = document.getElementById('filter-catalog-software');
    var filterOptions = $(filter.children[0]); // filter categories
    var filterHeight = filterOptions[0].scrollHeight; // filter categories height to be used when displaying it
    var showOptions = $(filter.children[1]); // Show categories div, has a click event
    var hideOptions = $(filter.children[2]); // Hide categories div, has a click event

    // If the hide categories div is visible and it is clicked,
    // hide the categories and display the show categories div
    if(hideOptions.is(':visible')){
      showOptions.show();
      hideOptions.hide();

      filterOptions.animate({
        height: 0
      },500);
    } else { // The user clicked on the show categories div, then show the categories and the "hide categories div"
      showOptions.hide();
      hideOptions.show();

      filterOptions.animate({
        height: filterHeight
      },500);
    }
  }

// If there is a software catalog on the page, add its category filter toggle animation
  function initialize() {
    var filter = document.getElementById('filter-catalog-software');
    if (filter) {
      //toggle filter options in catalog page
      filter.children[0].setAttribute('class', 'animated slideInDown');
      $(filter.children[1]).click(toggleFilterOptions);
      $(filter.children[2]).click(toggleFilterOptions);
    }
  }

  return {
    init: initialize
  };
}) (jQuery);

SPBNoosferoTheme.NoosferoFoldersContent = (function($) {
  'use strict';

  /* Splits a file name from its extension. Example: example.pdf becomes example - PDF */
  function split_file_extension(element) {
    var tokens = element.innerHTML.split('.');

    if(tokens.length > 1) {
      var fileExtension = tokens.pop().toUpperCase();
      var fileName = tokens.join('.');
      element.innerHTML = fileName + ' - ' + fileExtension;
    }
  }

  /* Finds all uploaded files from manuals page and sets its names on the right format */
  function set_uploaded_files_names() {
   try {
      var article = document.getElementById('article');
      var folderList = article.getElementsByClassName('folder-content')[0];
      var folderItens = folderList.getElementsByClassName('item-description');

      for(var i = 0, loop_length = folderItens.length; i < loop_length; i++) {
        split_file_extension(folderItens[i].getElementsByTagName('a')[0]);
      }
    } catch(e) {

    }
  }

  function initialize() {
    set_uploaded_files_names();
  }

  return {
    init: initialize
  };

}) (jQuery);

// Theme javascript bootstrap
(function(jQuery) {
  'use strict';

  // Initialize everything
  $(document).ready(function() {
    SPBNoosferoTheme.OrganizationRatings.init();
    SPBNoosferoTheme.HighlightedSoftwaresBlock.init();
    SPBNoosferoTheme.NoosferoHTMLAdjusts.init();
    SPBNoosferoTheme.SoftwareCatalog.init();
    SPBNoosferoTheme.NoosferoFoldersContent.init();
  });
}) (jQuery);
