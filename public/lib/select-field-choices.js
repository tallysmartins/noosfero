modulejs.define('SelectFieldChoices', ['jquery', 'SelectElement'], function($, SelectElement) {
  'use strict';


  function SelectFieldChoices(state_id, city_id, state_url) {
    this.state_id = state_id;
    this.input_html = $(state_id).parent().html();
    this.old_value = $(state_id).val();
    this.city_parent_div = $(city_id).parent().parent().parent();
    this.state_url = state_url;
  }


  SelectFieldChoices.prototype.getCurrentStateElement = function() {
    return $(this.state_id);
  };


  SelectFieldChoices.prototype.replaceWith = function(html) {
    var parent_div = this.getCurrentStateElement().parent();
    parent_div.html(html);
  };


  SelectFieldChoices.prototype.generateSelect = function(state_list) {
    var select_element, option;

    select_element = new SelectElement();
    select_element.setAttr("name", "profile_data[state]");
    select_element.setAttr("id", "state_field");
    select_element.setAttr("class", "type-select valid");

    state_list.forEach(function(state) {
      option = SelectElement.generateOption(state, state);
      select_element.addOption(option);
    });

    return select_element.getSelect();
  };


  SelectFieldChoices.prototype.replaceStateWithSelectElement = function() {
    var klass = this;

    $.get(this.state_url, function(response) {
      var select_html;

      if (response.length > 0) {
        select_html = klass.generateSelect(response);
        klass.replaceWith(select_html);

        if (klass.old_value.length !== 0 && response.include(klass.old_value)) {
          klass.getCurrentStateElement().val(klass.old_value);
        }
      }
    });
  };


  SelectFieldChoices.prototype.replaceStateWithInputElement = function() {
    this.replaceWith(this.input_html);
  };


  SelectFieldChoices.prototype.hideCity = function() {
    this.city_parent_div.addClass("mpog_hidden_field");
  };


  SelectFieldChoices.prototype.showCity = function() {
    this.city_parent_div.removeClass("mpog_hidden_field");
  };


  SelectFieldChoices.prototype.actualFieldIsInput = function() {
    return this.getCurrentStateElement().attr("type") === "text";
  };


  return SelectFieldChoices;
});
