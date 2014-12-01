require_dependency 'category'

class Category

	def software_infos
		software_list = self.communities
		software_list.collect{|x| software_list.delete(x) unless x.software? } 
		software_list
	end

end
