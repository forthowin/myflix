require 'spec_helper'

feature "user sign in" do
  scenario "with a valid account" do
    bob = Fabricate(:user, email: 'bob@myflix.com', password: 'password', full_name: 'Bob Bo')
    visit sign_in_path
    fill_in :email, with: 'bob@myflix.com'
    fill_in :password, with: 'password'
    click_button 'Sign in'
    expect(page).to have_content(bob.full_name)
  end

  scenario "with an invalid account" do
    visit sign_in_path
    fill_in :email, with: 'jim@myflix.com'
    fill_in :password, with: 'password'
    click_button 'Sign in'
    expect(page).to have_content('Invalid email or password.')
  end
end