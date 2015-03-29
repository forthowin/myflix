require 'spec_helper'

feature 'User resets their password' do
  scenario 'click link in their email to reset password' do
    bob = Fabricate(:user)

    visit sign_in_path
    click_link "Forgot Password?"
    fill_in "email", with: bob.email
    click_button "Send Email"
    expect(page).to have_content "We have send an email with instruction to reset your password."
    
    open_email(bob.email)
    current_email.click_link "Reset My Password"
    expect(page).to have_content "Reset Your Password"

    fill_in "password", with: 'password'
    click_button "Reset Password"
    expect(page).to have_content "Sign in"

    fill_in "email", with: bob.email
    fill_in "password", with: bob.password
    click_button "Sign in"
    expect(page).to have_content bob.full_name
  end
end