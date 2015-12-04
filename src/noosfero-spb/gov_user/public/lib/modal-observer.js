/* globals modulejs */

// Works on: IE 11, Edge 12+, Firefox 40+, Chrome 43+, Opera 32+, Safari 32+
modulejs.define("ModalObserver", function() {
  "use strict";

  function ModalObserver(target, callback) {
    this.action_callback = callback;
    this.observer = new MutationObserver(this.mutationVerifier.bind(this));

    this.observer.observe(target, {attributes: true});
  }


  ModalObserver.prototype.mutationVerifier = function(mutations) {
    var callback = this.action_callback;
    var observer = this.observer;

    mutations.forEach(function(mutation) {
      if (mutation.attributeName === "style" &&
          mutation.target.style.display === "none")
      {
        callback();
        // stop the observer, once its action is done
        observer.disconnect();
      }
    });
  };


  return {
    init: function(target, callback) {
      new ModalObserver(target, callback);
    }
  };
});
