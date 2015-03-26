require 'spec_helper'

feature "User following" do
  scenario "follow and unfollow another user" do
    bob = Fabricate(:user)
    comedy = Fabricate(:category, name: 'Comedy')
    futurama = Fabricate(:video, category: comedy)
    Fabricate(:review, user: bob, video: futurama)

    sign_in

    visit home_path
    click_on_a_video(futurama)

    click_user_and_follow(bob)
    expect_user_to_be_shown(bob)

    click_on_unfollow_link
    expect_user_to_not_be_shown(bob)
  end

  def click_on_a_video(video)
    find("a[href='/videos/#{video.id}']").click
  end

  def click_user_and_follow(user)
    click_link user.full_name
    click_link "Follow"
  end

  def expect_user_to_be_shown(user)
    page.should have_content user.full_name
  end

  def click_on_unfollow_link
    find("a[data-method='delete']").click
  end

  def expect_user_to_not_be_shown(user)
    page.should_not have_content user.full_name
  end
end
