class SoftwareHighlightsBlock < HighlightsBlock

  def self.description
    _('Software Highlights Block')
  end

  def help
    _('This block displays the softwares icon into a highlight')
  end
  
  def content(args={})
    softwares = self.settings[:images].collect {|h| h[:address].split('/').last}
    block = self
    proc do
      render :file => 'blocks/software_highlights', :locals => { :block => block, :softwares => softwares}
    end
  end


end
