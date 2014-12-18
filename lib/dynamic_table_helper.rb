class DynamicTableHelper
  extend(
    ActionView::Helpers::TagHelper,
    ActionView::Helpers::FormTagHelper,
    ActionView::Helpers::UrlHelper,
    ApplicationHelper
  )

  COLLUMN_NAME = {
    name: "name",
    version: "version",
    license: "license"
  }

  LABEL_TEXT = {
    :name => _("Name"),
    :version => _("Version"),
    :license => _("License")
  }

  DATA = {
    name: {
      label: LABEL_TEXT[:name],
      hidden: true,
      autocomplete: true,
      name: COLLUMN_NAME[:name],
    },
    version: {
      label: LABEL_TEXT[:version],
      name: COLLUMN_NAME[:version],
      hidden: true,
      delete: true,
    } ,
    license: {
      label: LABEL_TEXT[:license],
      name: COLLUMN_NAME[:license],
    }
  }
  @@disabled = false

  def self.table_html_structure data={}, disabled=false
    @@disabled = disabled
    Proc::new do
      content_tag :table , generate_table_lines(data), :class => "dynamic-table"
    end
  end

  def self.generate_table_lines data={}
    @@model = data[:model_name].to_css_class
    @@field_name = data[:field_name]
    @@hidden_label = data[:name][:value]
    @@hidden_id = data[:name][:id]

    row_data = prepare_row_data data

    table_line_data = [
      self.table_line(row_data[:name]),
      self.table_line(row_data[:version])
    ]

    if row_data[:license].has_key? :value
      table_line_data << self.table_line(row_data[:license])
    end

    table_line_data.join()
  end

  def self.table_line row_data={}
    unless row_data.blank?
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
          :class => "#{@@model}_autocomplete",
          :placeholder => _("Autocomplete field, type something")
        }
      else
        {}
      end

    html_options[:disabled] = @@disabled
    if autocomplete
      content_tag :td, text_field_tag("#{@@model}_autocomplete", value, html_options)
    else
      content_tag :td, text_field_tag("#{@@model}[][#{name}]", value, html_options)
    end
  end

  def self.hidden_collumn delete=false, hidden_data=false
    value =
      if @@disabled
        nil
      elsif delete
        button_without_text(
          :delete, _('Delete'), "#" , :class=>"delete-dynamic-table"
        )
      elsif hidden_data
        hidden_field_tag(
          "#{@@model}[][#{@@field_name}]",
          @@hidden_id,
          :class => "#{@@field_name}",
          :data => {:label => @@hidden_label } #check how to get the name of an object of the current model
        )
      else
        nil
      end

    content_tag(:td, value, :align => 'right')
  end

  def self.prepare_row_data data
    row_data = {
      name: DATA[:name],
      version: DATA[:version],
      license: DATA[:license]
    }

    row_data[:name].merge! data[:name]
    row_data[:version].merge! data[:version]
    row_data[:license].merge! data[:license] if data.has_key? :license

    row_data
  end

  def self.models_as_tables models, callback, disabled=false
    lambdas_list = []

    models.map do |model|
      send(callback, model, disabled)
    end
  end
end