class Download < ActiveRecord::Base

  self.table_name = "software_communities_downloads"
  attr_accessible :name, :link, :software_description, :minimum_requirements, :size, :total_downloads, :download_block

  belongs_to :download_block

  validates_presence_of :name, :link, :size
  validates :total_downloads, numericality: { only_integer: true }
end
