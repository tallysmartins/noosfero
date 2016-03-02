class DownloadBlock < Block

  attr_accessible :show_name, :downloads

  has_many :download_records, :class_name => 'Download', :dependent => :destroy

  settings_items :show_name, :type => :boolean, :default => false
  settings_items :downloads, :type => Array, :default => []

  after_save :update_downloads

  def update_downloads
    self.downloads = self.downloads.select{|download| !download.all?{|k, v| v.blank?}}

    params_download_ids = self.downloads.select{|download| !download[:id].blank?}.collect{|download| download[:id].to_i}
    removed_download_ids = self.download_record_ids - params_download_ids
    Download.where(:id => removed_download_ids).destroy_all

    self.downloads.each do |download_hash|
      download_record = Download.find_by_id(download_hash[:id].to_i)
      download_record ||= Download.new(:download_block => self)
      download_record.update_attributes(download_hash)
      download_hash[:id] = download_record.id
    end
  end

  def self.description
    _('Download Stable Version')
  end

  def help
    _('This block displays the stable version of a software.')
  end

  def content(args={})
    block = self
    s = show_name
    lambda do |object|
      render(
        :file => 'blocks/download',
        :locals => { :block => block, :show_name => s }
      )
    end
  end

  def cacheable?
    false
  end

  def uploaded_files
    downloads_folder = Folder.find_or_create_by_profile_id_and_name(owner.id, "Downloads")
    get_nodes(downloads_folder.children)
  end

  private

  def get_nodes(folder)
    nodes = []
    folder.each do |article|
      if article.type == "UploadedFile"
        nodes << article
      end
      nodes += get_nodes(article.children)
    end
    nodes
  end
end
