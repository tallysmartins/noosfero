require_dependency 'search_helper'

module SearchHelper

  COMMON_PROFILE_LIST_BLOCK ||= []
  COMMON_PROFILE_LIST_BLOCK << :software_infos
  COMMON_PROFILE_LIST_BLOCK << :institutions

  def sort_by_relevance list, text
    text_splited = text.split

    relevance_map = {}
    list.each do |element|
      relevance_map[element] = yield(element)
    end

    list.sort! do |a, b|
      found_in_a, found_in_b = 1, 1

      relevance_list_a = relevance_map[a]
      relevance_list_b = relevance_map[b]

      text_splited.each do |q|
        relevance_list_a.count.times do |i|
          relevance = i * -1
          found_in_a = relevance if relevance_list_a[i].downcase.include?(q.downcase)
          found_in_b = relevance if relevance_list_b[i].downcase.include?(q.downcase)
        end
      end

      found_in_a <=> found_in_b
    end

    list
  end

end
