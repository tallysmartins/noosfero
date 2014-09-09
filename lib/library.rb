class Library < ActiveRecord::Base

  #TODO missing relations?

  attr_accessible :name, :version, :license, :software_info_id

  validate :validate_name, :validate_version, :validate_license
  validates :name, length: { within: 0..20 }
  validates_length_of :version, maximum: 20, too_long: _("Library is too long (maximum is 20 characters)")
  validates_length_of :license, maximum: 20, too_long: _("Library is too long (maximum is 20 characters)")

  def validate_name
    self.errors.add(:name, _("can't be blank")) if self.name.blank? && self.errors[:name].blank?
  end

  def validate_version
    self.errors.add(:version, _("can't be blank")) if self.version.blank? && self.errors[:version].blank?
  end

  def validate_license
    self.errors.add(:license, _("can't be blank")) if self.license.blank? && self.errors[:license].blank?
  end

end
