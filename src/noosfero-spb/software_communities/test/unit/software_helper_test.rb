require 'test_helper'

class SoftwareHelperTest < ActiveSupport::TestCase

  include SoftwareHelper

  should "Create ProgrammingLanguages based on file with languages names" do
    ProgrammingLanguage.delete_all
    PATH_TO_FILE = "plugins/software_communities/public/static/languages.txt"

    SoftwareHelper.create_list_with_file(PATH_TO_FILE, ProgrammingLanguage)

    list = File.open(PATH_TO_FILE, "r")
    count = list.readlines.count
    list.close

    assert(ProgrammingLanguage.count == count)
  end

end
