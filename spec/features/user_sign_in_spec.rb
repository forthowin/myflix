require 'spec_helper'

feature "user sign in" do
  scenario "with a valid account" do
    bob = Fabricate(:user)
    sign_in(bob)
    expect(page).to have_content(bob.full_name)
  end

  scenario "with a deactivated account" do
    bob = Fabricate(:user, active: false)
    sign_in(bob)
    expect(page).not_to have_content(bob.full_name)
    expect(page).to have_content("Your account has been suspended. Contact customer service for more info.")
  end
end