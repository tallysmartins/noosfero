module ControlledVocabularyHelper

  def self.get_categories_as_options
    categories = ["<option>Any</option>".html_safe]

    ControlledVocabulary.attribute_names.each do |attribute|
      if attribute.to_s != "id" && attribute.to_s != "software_info_id" then
        categories << "<option>#{attribute.titleize}</option>".html_safe
      end
    end

    categories
  end
end
