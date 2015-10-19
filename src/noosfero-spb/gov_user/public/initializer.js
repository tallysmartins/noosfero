/* globals modulejs */

(function() {
  'use strict';

  var dependencies = [
    'ControlPanel',
    'CreateInstitution',
    'CompleteRegistration',
    'UserEditProfile',
    'NewCommunity',
    'GovUserCommentsExtraFields'
  ];


  modulejs.define('Initializer', dependencies, function() {
    var __dependencies = arguments;


    function call_dependency(dependency) {
      if( dependency.isCurrentPage() ) {
        dependency.init();
      }
    }


    return {
      init: function() {
        for(var i=0, len = __dependencies.length; i < len; i++) {
          call_dependency(__dependencies[i]);
        }
      }
    };
  });
})();
