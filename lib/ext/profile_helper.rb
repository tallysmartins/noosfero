require_dependency 'profile_helper'

module ProfileHelper
  PERSON_CATEGORIES[:mpog_profile_information] = [:secondary_email,
                                                  :institutions]

  def display_mpog_field(title, profile, field, force = false)
    unless force || profile.may_display_field_to?(field, user)
      return ''
    end
    value = profile.send(field)
    if !value.blank?
      if block_given?
        value = yield(value)
      end
      content_tag(
        'tr',
        content_tag('td', title, :class => 'field-name') +
        content_tag('td', value)
      )
    else
      ''
    end
  end

end
