require_dependency 'person'

class Person

  settings_items :area_interest, :type => :string, :default => ""
  settings_items :percentage_incomplete, :type => :string, :default => ""

  attr_accessible :area_interest
  attr_accessible :percentage_incomplete

  scope :search, lambda { |name="", state="", city="", email=""|
    like_sql = ""
    values = []

    unless name.nil? and name.blank?
      like_sql << "name ILIKE ? AND "
      values << "%#{name}%"
    end

    unless state.nil? and state.blank?
      like_sql << "data ILIKE ? AND "
      values << "%:state: %#{state}%"
    end

    unless city.nil? and city.blank?
      like_sql << "data ILIKE ? AND "
      values << "%:city: %#{city}%"
    end

    unless email.nil? and email.blank?
      like_sql << "email ILIKE ? AND "
      values << "%#{email}%"
    end
    like_sql = like_sql[0..like_sql.length-5]

    { 
      :joins => :user, 
      :conditions=>[like_sql, *values]
    }
  }

  def secondary_email
    self.user.secondary_email unless self.user.nil?
  end

  def secondary_email= value
    self.user.secondary_email = value unless self.user.nil?
  end

  def institution
    self.user.institution.name if self.user and self.user.institution
  end

  def institution_id
    self.user.institution.id unless self.user.institution.nil?
  end

  def institution_id= value
    institution = Institution.find(:first, :conditions=>"id = #{value}")

    unless institution.nil?
      self.user.institution = institution
    end
  end

  def software?
    false
  end
end
