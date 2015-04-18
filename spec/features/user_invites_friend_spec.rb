require 'spec_helper'

feature "User invites friend" do
  scenario "friend accepts invitation and the two follows each other", {js: true, vcr: true} do
    bob = Fabricate(:user)
    sign_in(bob)

    invite_a_friend
    friend_accepts_invitation

    friend_should_follow(bob)
    inviter_should_follow_friend(bob)

    clear_email
  end

  def invite_a_friend
    visit invite_path
    fill_in "Friend's Name", with: "Jim"
    fill_in "Friend's Email Address", with: "jim@example.com"
    fill_in "Invitation Message", with: "Hey man, join this awesome site!"
    click_button "Send Invitation"
    sign_out
  end

  def friend_accepts_invitation
    open_email("jim@example.com")
    current_email.click_link "Create an account at myflix"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Jim Jo"
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2018", from: "date_year"
    click_button "Sign Up"
  end

  def friend_should_follow(user)
    click_link "People"
    expect(page).to have_content user.full_name
    sign_out
  end

  def inviter_should_follow_friend(user)
    sign_in(user)
    click_link "People"
    expect(page).to have_content "Jim Jo"
  end
end