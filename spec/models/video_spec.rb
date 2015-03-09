require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order("created_at DESC") }

  describe ".search_by_title" do
    it "returns an empty array if there is no match" do
      family_guy = Video.create(title: 'Family Guy', description: 'Funny show')
      south_park = Video.create(title: 'South Park', description: 'Funny show')
      expect(Video.search_by_title("familly")).to eq([])
    end

    it "returns an array of one video if there is an exact match" do
      family_guy = Video.create(title: 'Family Guy', description: 'Funny show')
      south_park = Video.create(title: 'South Park', description: 'Funny show')
      expect(Video.search_by_title("Family Guy")).to eq([family_guy])
    end

    it "returns an array of one video if there is a similar match" do
      family_guy = Video.create(title: 'Family Guy', description: 'Funny show')
      south_park = Video.create(title: 'South Park', description: 'Funny show')
      expect(Video.search_by_title("Fam")).to eq([family_guy])
    end

    it "returns an array of all matches in order of created_at" do
      family_guy = Video.create(title: 'Family Guy', description: 'Funny show', created_at: 1.day.ago)
      family_man = Video.create(title: 'Family Man', description: 'Funny show')
      expect(Video.search_by_title("Family")).to eq([family_man, family_guy])
    end 

    it "returns an empty array a search with an empty string" do
      family_guy = Video.create(title: 'Family Guy', description: 'Funny show')
      south_park = Video.create(title: 'South Park', description: 'Funny show')
      expect(Video.search_by_title("")).to eq([])
    end

    it "returns an array of one video if there is a similar match case insensitive" do
      family_guy = Video.create(title: 'Family Guy', description: 'Funny show')
      south_park = Video.create(title: 'South Park', description: 'Funny show')
      expect(Video.search_by_title("fam")).to eq([family_guy])
    end
  end
end