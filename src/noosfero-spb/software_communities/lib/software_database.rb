class SoftwareDatabase < ActiveRecord::Base
  attr_accessible :version

  belongs_to :software_info
  belongs_to :database_description

  validates_presence_of :database_description_id, :version

  validates_length_of(
    :version,
    :maximum => 20,
    :too_long => _("Software database is too long (maximum is 20 characters)")
  )

  validates(
    :database_description_id,
    :numericality => {:greater_than_or_equal_to => 1}
  )

end
