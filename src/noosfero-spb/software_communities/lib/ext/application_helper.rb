require_dependency "application_helper"

ApplicationHelper.class_eval do

  def number_to_human(value)
    number_with_delimiter(value, :separator => environment.currency_separator, :delimiter => environment.currency_delimiter)
  end
end
