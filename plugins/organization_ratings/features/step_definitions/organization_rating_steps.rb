Given /^the following organization ratings$/ do |table|
  table.hashes.each do |item|
    person = User.where(login: item[:user_login]).first.person
    organization = Organization.where(name: item[:organization_name]).first

    rating = OrganizationRating.new
    rating.value = item[:value]
    rating.organization_id = organization.id
    rating.person_id = person.id
    rating.save

    comment_task = CreateOrganizationRatingComment.create!(
      :body => item[:comment_body],
      :requestor => person,
      :organization_rating_id => rating.id,
      :target => organization)

    comment_task.status = item[:task_status]
    comment_task.save
  end
end
