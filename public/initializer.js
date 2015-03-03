var dependencies = [
  'ControlPanel',
  'EditSoftware',
  'NewSoftware',
  'UserEditProfile'
];


modulejs.define('Initializer', dependencies, function(cp, es, ns, uep) {
  'use strict';


  return {
    init: function() {
      if( cp.isControlPanel() ) {
        cp.init();
      }


      if( es.isEditSoftware() ) {
        es.init();
      }


      if( ns.isNewSoftware() ) {
        ns.init();
      }


      if( uep.isUserEditProfile() ) {
        uep.init();
      }
    }
  };
});
