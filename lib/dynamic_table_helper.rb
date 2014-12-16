module DynamicTableHelper
  extend(
    ActionView::Helpers::TagHelper,
    ActionView::Helpers::FormTagHelper,
    ActionView::Helpers::UrlHelper,
    ApplicationHelper
  )

  LABEL_TEXT = {
    :name => _("Name"),
    :version => _("Version"),
    :license => _("License")
  }
  @disabled = false

  def self.table_html_structure data={}, disabled=false
    @disabled = disabled
    Proc::new do
      content_tag :table , DynamicTableHelper.generate_table_lines(data), :class => "dynamic-table"
    end
  end

  def self.generate_table_lines data={}
    @model = data[:model_name].to_css_class
    @field_name = data[:field_name]
    @value = data[:name][:value]
    @hidden_id = data[:name][:id]

    [
      self.table_line(data[:name]),
      self.table_line(data[:version]),
      self.table_line(data[:license])
    ].join()
  end

  def self.table_line row_data={}
    if !row_data.blank?
      content_tag :tr, [
        self.label_collumn(row_data[:label]),
        self.value_collumn(row_data[:value], row_data[:name], row_data[:autocomplete]),
        self.hidden_collumn(row_data[:delete], row_data[:hidden])
      ].join()
    end
  end

  def self.label_collumn label=""
    content_tag :td, label_tag(label)
  end

  def self.value_collumn value="", name="", autocomplete=false, disabled=false
    html_options =
      if autocomplete
        {
          :class => "#{@model}_autocomplete",
          :placeholder => _("Autocomplete field, type something")
        }
      else
        {}
      end

    html_options[:disabled] = @disabled
    if autocomplete
      content_tag :td, text_field_tag("#{@model}_autocomplete", value, html_options)
    else
      content_tag :td, text_field_tag("#{@model}[][#{name}]", value, html_options)
    end
  end

  def self.hidden_collumn delete=false, hidden_data=false
    value =
      if @disabled
        nil
      elsif delete
        button_without_text(
          :delete, _('Delete'), "#" , :class=>"delete-dynamic-table"
        )
      elsif hidden_data
        hidden_field_tag(
          "#{@model}[][#{@field_name}]",
          @hidden_id,
          :class => "#{@field_name}",
          :data => {:label => @value } #check how to get the name of an object of the current model
        )
      else
        nil
      end
    content_tag(:td, value, :align => 'right')
  end
end