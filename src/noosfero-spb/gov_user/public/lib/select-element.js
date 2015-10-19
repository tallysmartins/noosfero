/* globals modulejs */

modulejs.define('SelectElement', function() {
  'use strict';


  function SelectElement(name, id) {
    this.select = document.createElement("select");
  }


  SelectElement.prototype.setAttr = function(attr, value) {
    return this.select.setAttribute(attr, value);
  };


  SelectElement.prototype.addOption = function(option) {
    return this.select.add(option);
  };


  SelectElement.prototype.getSelect = function() {
    return this.select;
  };


  SelectElement.generateOption = function(value, text) {
    var option;
    option = document.createElement("option");
    option.setAttribute("value", value);
    option.text = text;
    return option;
  };


  return SelectElement;
});
