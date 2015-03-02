var dependencies = [
  'ControlPanel'
];


modulejs.define('Initializer', dependencies, function(cp) {
  if( cp.isControlPanel() ) {
    cp.init();
  }
});


(function() {
  'use strict';

  var $ = modulejs.require('jquery');
  Initializer = modulejs.require('Initializer');


  $(document).ready(function() {
    Initializer();
  });
})();