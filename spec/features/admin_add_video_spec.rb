require 'spec_helper'

feature "admin add a video" do
  scenario "video is added successfully" do
    admin = Fabricate(:admin)
    drama = Fabricate(:category, name: "Drama")

    sign_in(admin)
    visit new_admin_video_path

    fill_in "Title", with: "Monk"
    select "Drama", from: "Category"
    fill_in "Description", with: "TV show"
    attach_file "Large cover", "spec/support/uploads/monk_large.jpg"
    attach_file "Small cover", "spec/support/uploads/monk.jpg"
    fill_in "Video URL", with: "www.example.com/video.mp4"
    click_button "Add Video"

    sign_out
    sign_in

    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='www.example.com/video.mp4']")
  end
end