var dependencies = [
  'ControlPanel',
  'EditSoftware'
];


modulejs.define('Initializer', dependencies, function(cp, es) {
  return {
    init: function() {
      if( cp.isControlPanel() ) {
        cp.init();
      }


      if( es.isEditSoftware() ) {
        es.init();
      }
    }
  };
});
