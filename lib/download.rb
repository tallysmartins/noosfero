#FIX ME: Turn this into a proper model(next release)
class Download
  def initialize data
    @name = data[:name]
    @link = data[:link]
    @software_description = data[:software_description]
    @minimum_requirements = data[:minimum_requirements]
    @size = data[:size]

    @total_downloads = if data[:total_downloads]
      data[:total_downloads]
    else
      0
    end
  end

  def self.validate_download_list download_list
    download_list.select! do |download|
      not download[:name].blank?
    end

    download_list.map do |download|
      Download.new(download).to_hash
    end
  end

  def to_hash
    {
      :name => @name,
      :link => @link,
      :software_description => @software_description,
      :minimum_requirements => @minimum_requirements,
      :size => @size,
      :total_downloads => @total_downloads
    }
  end

  def total_downloads= value
    if value.is_a? Integer
      @total_downloads = value
    end
  end

  def total_downloads
    @total_downloads
  end

  def link
    @link
  end
end
