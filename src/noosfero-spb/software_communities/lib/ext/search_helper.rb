require_dependency 'search_helper'

module SearchHelper

  COMMON_PROFILE_LIST_BLOCK ||= []
  COMMON_PROFILE_LIST_BLOCK << :software_infos

  def sort_by_relevance list, text
    text_splited = text.split

    element_relevance = {}

    list.each do |element|
      relevance = 1
      relevance_list = yield(element)

      text_splited.each do |t|
        relevance_list.count.times do |i|
          relevance = -1 * i if relevance_list[i].downcase.include?(t.downcase)
        end
      end

      element_relevance[element] = relevance
    end

    list.sort! do |a, b|
      element_relevance[a] <=> element_relevance[b]
    end

    list
  end

  def sort_by_average_rating list
    list.sort! do |a, b|
      rating_a = OrganizationRating.average_rating(a.id)
      rating_a = 0 if rating_a.nil?
      rating_b = OrganizationRating.average_rating(b.id)
      rating_b = 0 if rating_b.nil?
      rating_a - rating_b
    end

    list.reverse!
  end

end
