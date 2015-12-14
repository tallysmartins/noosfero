class SoftwareCommunitiesPlugin::AllowVariables < Noosfero::Plugin::Macro
  def self.configuration
    { :params => [],
      :skip_dialog => true,
      :title => _("Insert Profile"),
      :generator => 'insertProfile();',
      :js_files => 'allow_variables.js',
      :icon_path => '/designs/icons/tango/Tango/16x16/actions/document-properties.png'
    }
  end

  def parse(params, inner_html, source)
    source.profile.identifier
  end
end
