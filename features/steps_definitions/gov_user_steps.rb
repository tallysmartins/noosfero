Given /^Institutions has initial default values on database$/ do
  GovernmentalPower.create(:name => "Executivo")
  GovernmentalPower.create(:name => "Legislativo")
  GovernmentalPower.create(:name => "Judiciario")

  GovernmentalSphere.create(:name => "Federal")

  JuridicalNature.create(:name => "Autarquia")
  JuridicalNature.create(:name => "Administracao Direta")
  JuridicalNature.create(:name => "Empresa Publica")
  JuridicalNature.create(:name => "Fundacao")
  JuridicalNature.create(:name => "Orgao Autonomo")
  JuridicalNature.create(:name => "Sociedade")
  JuridicalNature.create(:name => "Sociedade Civil")
  JuridicalNature.create(:name => "Sociedade de Economia Mista")

  national_region = NationalRegion.new
  national_region.name = "Distrito Federal"
  national_region.national_region_code = '35'
  national_region.national_region_type_id = NationalRegionType::STATE
  national_region.save
end

Given /^I type in "([^"]*)" in autocomplete list "([^"]*)" and I choose "([^"]*)"$/ do |typed, input_field_selector, should_select|
# Wait the page javascript load
sleep 1
# Basicaly it, search for the input field, type something, wait for ajax end select an item
page.driver.browser.execute_script %Q{
  var search_query = "#{input_field_selector}.ui-autocomplete-input";
  var input = jQuery(search_query).first();

  input.trigger('click');
  input.val('#{typed}');
  input.trigger('keydown');

  window.setTimeout(function(){
    search_query = ".ui-menu-item a:contains('#{should_select}')";
    var typed = jQuery(search_query).first();

    typed.trigger('mouseenter').trigger('click');
    console.log(jQuery('#license_info_id'));
    }, 1000);
  }
  sleep 1
end

Given /^the following public institutions?$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each do |item|
    community = Community.new
    community.name = item[:name]
    community.country = item[:country]
    community.state = item[:state]
    community.city = item[:city]
    community.save!

    governmental_power = GovernmentalPower.where(:name => item[:governmental_power]).first
    governmental_sphere = GovernmentalSphere.where(:name => item[:governmental_sphere]).first

    juridical_nature = JuridicalNature.create(:name => item[:juridical_nature])

    institution = PublicInstitution.new(:name => item[:name], :type => "PublicInstitution", :acronym => item[:acronym], :cnpj => item[:cnpj], :juridical_nature => juridical_nature, :governmental_power => governmental_power, :governmental_sphere => governmental_sphere)
    institution.community = community
    institution.corporate_name = item[:corporate_name]
    institution.save!
  end
end

Given /^I sleep for (\d+) seconds$/ do |time|
  sleep time.to_i
end

Given /^I am logged in as mpog_admin$/ do
  visit('/account/logout')

  user = User.new(:login => 'admin_user', :password => '123456', :password_confirmation => '123456', :email => 'admin_user@example.com')
  person = Person.new :name=>"Mpog Admin", :identifier=>"mpog-admin"
  user.person = person
  user.save!

  user.activate
  e = Environment.default
  e.add_admin(user.person)

  visit('/account/login')
  fill_in("Username", :with => user.login)
  fill_in("Password", :with => '123456')
  click_button("Log in")
end

