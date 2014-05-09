require 'test_helper'

class SearchTermTest < ActiveSupport::TestCase
  should 'have term' do
    search_term = SearchTerm.new
    assert !search_term.valid?
    assert search_term.errors.has_key?(:term)
  end

  should 'have context' do
    search_term = SearchTerm.new
    assert !search_term.valid?
    assert search_term.errors.has_key?(:context)
  end

  should 'have unique term within specific context and asset' do
    SearchTerm.create!(:term => 'galaxy', :context => Environment.default, :asset => 'universe')
    search_term = SearchTerm.new(:term => 'galaxy', :context => Environment.default, :asset => 'universe')
    search_term.valid?
    assert search_term.errors.has_key?(:term)

    search_term.asset = 'alternate_universe'
    search_term.valid?
    assert !search_term.errors.has_key?(:term)
  end

  should 'create a search term' do
    assert_nothing_raised do
      SearchTerm.create!(:term => 'universe', :context => Environment.default)
    end
  end

  should 'find or create by term' do
    assert_difference 'SearchTerm.count', 1 do
      SearchTerm.find_or_create('universe', Environment.default)
      search_term = SearchTerm.find_or_create('universe', Environment.default)
      assert_equal 'universe', search_term.term
    end
  end

  should 'have occurrences' do
    search_term = SearchTerm.find_or_create('universe', Environment.default)
    o1 = SearchTermOccurrence.create!(:search_term => search_term)
    o2 = SearchTermOccurrence.create!(:search_term => search_term)

    assert_equivalent [o1,o2], search_term.occurrences
  end

  should 'calculate score' do
    search_term = SearchTerm.find_or_create('universe', Environment.default)
    SearchTermOccurrence.create!(:search_term => search_term, :total => 10, :indexed => 3)
    # Search term must happens at least two times to be considered
    SearchTermOccurrence.create!(:search_term => search_term, :total => 10, :indexed => 3)
    search_term.calculate_score
    assert search_term.score > 0, "Score was not calculated."
  end

  should 'not consider expired occurrences to calculate the score' do
    search_term = SearchTerm.find_or_create('universe', Environment.default)
    occurrence = SearchTermOccurrence.create!(:search_term => search_term, :total => 10, :indexed => 3, :created_at => DateTime.now - (SearchTermOccurrence::EXPIRATION_TIME + 1.day))
    search_term.calculate_score
    assert search_term.score == 0, "Considered expired occurrence to calculate the score."
  end

  should 'calculate search_terms scores' do
    st1 = SearchTerm.find_or_create('st1', Environment.default)
    SearchTermOccurrence.create!(:search_term => st1, :total => 10, :indexed => 3)
    SearchTermOccurrence.create!(:search_term => st1, :total => 20, :indexed => 8)
    SearchTermOccurrence.create!(:search_term => st1, :total => 30, :indexed => 9)
    st2 = SearchTerm.find_or_create('st2', Environment.default)
    SearchTermOccurrence.create!(:search_term => st2, :total => 10, :indexed => 7)
    SearchTermOccurrence.create!(:search_term => st2, :total => 20, :indexed => 16)
    SearchTermOccurrence.create!(:search_term => st2, :total => 30, :indexed => 21)

    SearchTerm.calculate_scores
    st1.reload
    st2.reload

    assert st1.score > 0, "Did not calculate st1 score."
    assert st2.score > 0, "Did not calculate st2 score."
  end

end
