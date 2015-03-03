var dependencies = [
  'ControlPanel',
  'EditSoftware',
  'NewSoftware'
];


modulejs.define('Initializer', dependencies, function(cp, es, ns) {
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
    }
  };
});
