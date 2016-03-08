class SoftwareCommunitiesPlugin::SispTabDataBlock < SoftwareCommunitiesPlugin::SoftwareTabDataBlock
  def self.description
    _('Sisp Tab Data')
  end

  def help
    _('This block is used to display SISP Data')
  end

  def content(args={})
    block = self

    lambda do |object|
      render(
        :file => 'blocks/sisp_tab_data',
        :locals => {
          :block => block
        }
      )
    end
  end

end
