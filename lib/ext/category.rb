require_dependency 'category'

class Category

	SOFTWARE_CATEGORIES = [
		_("Agriculture, Fisheries and Extraction"),
		_("Science, Information and Communication"),
		_("Economy and Finances"),
		_("Public Administration"),
		_("Habitation, Sanitation and Urbanism"),
		_("Individual, Family and Society"),
		_("Health"),
		_("Social Welfare and Development"),
		_("Defense and Security"),
		_("Education"),
		_("Government and Politics"),
		_("Justice and Legislation"),
		_("International Relationships")
	]

	def software_infos
		software_list = self.communities
		software_list.collect{|x| software_list.delete(x) unless x.software? }
		software_list
	end

end
