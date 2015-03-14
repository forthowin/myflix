require 'spec_helper'

feature "User interacts with the queue" do
  scenario "add and reorder the queue items" do
    comedy = Fabricate(:category, name: 'Comedy')
    futurama = Fabricate(:video, title: 'Futurama', category: comedy)
    south_park = Fabricate(:video, title: 'South Park', category: comedy)
    family_guy = Fabricate(:video, title: 'Family Guy', category: comedy)

    sign_in

    add_video_to_queue(futurama)

    expect_video_to_be_in_queue(futurama)

    visit video_path(futurama)
    expect_link_to_not_show('+ My Queue')

    add_video_to_queue(south_park)
    add_video_to_queue(family_guy)

    set_video_position(futurama, 3)
    set_video_position(south_park, 1)
    set_video_position(family_guy, 2)

    expect_video_position(south_park, 1)
    expect_video_position(family_guy, 2)
    expect_video_position(futurama, 3)

  end

  def expect_link_to_not_show(link_text)
    page.should_not have_content '#{link_text}'
  end

  def expect_video_to_be_in_queue(video)
    page.should have_content video.title
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link '+ My Queue'
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(., '#{video.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(., '#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end


end