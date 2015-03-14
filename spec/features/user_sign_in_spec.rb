require 'spec_helper'

feature "user sign in" do
  scenario "with a valid account" do
    bob = Fabricate(:user, email: 'bob@myflix.com', password: 'password', full_name: 'Bob Bo')
    sign_in(bob)
    expect(page).to have_content(bob.full_name)
  end
end