module SoftwareCategoriesHelper

  def self.get_categories_as_options
    categories = ["<option value = #{""} >Any</option>".html_safe]
    value = 1

    SoftwareCategories.attribute_names.each do |attribute|
      if attribute.to_s != "id" && attribute.to_s != "software_info_id" then
        categories << "<option value = #{attribute} >#{attribute.titleize}</option>".html_safe
        value+=1
      end
    end
    categories
  end
end
