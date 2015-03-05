require 'spec_helper'

describe Category do
  it { should have_many(:videos)}

  describe "#recent_videos" do
    it "returns an empty array when no videos are present" do
      cat = Category.create(name: 'TV Comedy')
      expect(cat.recent_videos).to eq([])
    end

    it "returns an array of videos in reverse chronological order" do
      cat = Category.create(name: 'TV Comedy')
      south_park = Video.create(title: 'South Park', description: 'Funny show.', category: cat, created_at: 1.day.ago)
      futurama = Video.create(title: 'Futurama', description: 'Funny show.', category: cat)
      expect(cat.recent_videos).to eq([futurama, south_park])
    end

    it 'returns all videos when there are less than 6 videos' do
      cat = Category.create(name: 'TV Comedy')
      south_park = Video.create(title: 'South Park', description: 'Funny show.', category: cat, created_at: 1.day.ago)
      futurama = Video.create(title: 'Futurama', description: 'Funny show.', category: cat)
      expect(cat.recent_videos.count).to eq(2)
    end

    it 'returns 6 videos when there are more than 6 videos' do
      cat = Category.create(name: 'TV Comedy')
      7.times { Video.create(title: 'South Park', description: 'Funny show', category: cat)}
      expect(cat.recent_videos.count).to eq(6)
    end

    it "returns 6 most recent videos" do
      cat = Category.create(name: 'TV Comedy')
      6.times { Video.create(title: 'South Park', description: 'Funny show', category: cat)}
      family_guy = Video.create(title: 'Family Guy', description: 'Funny show', category: cat, created_at: 1.day.ago)
      expect(cat.recent_videos).not_to include(family_guy)
    end
  end
end