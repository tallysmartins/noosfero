class SoftwareInformationBlock < Block

  def self.description
    _('Basic Software Information')
  end

  def help
    _('This block displays the basic information of a software profile.')
  end

  def content(args={})
    block = self
    s = show_name
    lambda do |object|
      render(
        :file => 'blocks/software_information',
        :locals => { :block => block, :show_name => s }
      )
    end
  end

  def cacheable?
    false
  end
end
