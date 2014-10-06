# encoding: utf-8

require_dependency 'person'

class Person

  settings_items :percentage_incomplete, :type => :string, :default => ""

  attr_accessible :percentage_incomplete

  validate :validate_full_name

  scope :search, lambda { |name="", state="", city="", email=""|
    like_sql = ""
    values = []

    unless name.blank?
      like_sql << "name ILIKE ? OR identifier ILIKE ? AND "
      values << "%#{name}%" << "%#{name}%"
    end

    unless state.blank?
      like_sql << "data ILIKE ? AND "
      values << "%:state: %#{state}%"
    end

    unless city.blank?
      like_sql << "data ILIKE ? AND "
      values << "%:city: %#{city}%"
    end

    unless email.blank?
      like_sql << "email ILIKE ? AND "
      values << "%#{email}%"
    end
    like_sql = like_sql[0..like_sql.length-5]

    { 
      :joins => :user, 
      :conditions=>[like_sql, *values]
    }
  }

  def institutions
    institutions = []
    unless self.user.institutions.nil?
      self.user.institutions.each do |institution|
        institutions << institution.name
      end
    end
    institutions
  end

  def secondary_email
    self.user.secondary_email unless self.user.nil?
  end

  def secondary_email= value
    self.user.secondary_email = value unless self.user.nil?
  end

  def validate_full_name
    full_validation = /([^\w\*\s*])|(^|\s)([a-z]|[0-9])/
    partial_validation = /[^\w\*\s]/
    invalid = false

    return false if self.name.blank?

    validation_name = replace_some_special_chars(self.name)

    validation_name.split(" ").each do |value|
      invalid = if value.length > 3
        full_validation.match(value)
      else
        partial_validation.match(value)
      end
    end

    if invalid
      self.errors.add(:name, _("Should begin with a capital letter and no special characters"))
      return false
    end
    true
  end

  def software?
    false
  end

  private

  def replace_some_special_chars text
    text.gsub(/([áàâãéèêíïóôõöú])/) do |value|
      if( ["á","à","â","ã"].include?(value) )
        "a"
      elsif( ["é","è","ê"].include?(value) )
        "e"
      elsif( ["í","ï"].include?(value) )
        "i"
      elsif ( ["ó","ô","õ","ö"].include?(value) )
        "o"
      elsif( ["ú"].indexOf(value) )
        "u"
      else
        value
      end
    end
  end
end
