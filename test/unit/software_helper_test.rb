require File.dirname(__FILE__) + '/../../../../test/test_helper'

class SoftwareHelperTest < ActiveSupport::TestCase

  include SoftwareHelper

  should "Create ProgrammingLanguages based on file with languages names" do
    ProgrammingLanguage.delete_all
    SoftwareHelper.create_list_with_file("plugins/mpog_software/public/static/languages.txt", ProgrammingLanguage)

    list = File.open("plugins/mpog_software/public/static/languages.txt", "r")
    count = list.readlines.count
    list.close

    assert(ProgrammingLanguage.count == count)
  end

end
