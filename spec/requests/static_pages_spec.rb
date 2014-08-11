require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do

    it "/home には 'ほーむ' という言葉が含まれる" do
      visit '/static_pages/home'
      expect(page).to have_content('ほーむ')
    end

    it "/home は以下のtitleを保有する" do
      visit '/static_pages/home'
      expect(page).to have_title("Sample App | ほーむ")
    end

    it "/help には 'へるぷ' という言葉が含まれる" do
      visit '/static_pages/help'
      expect(page).to have_content('へるぷ')
    end

    it "/help は以下のtitleを保有する" do
      visit '/static_pages/help'
      expect(page).to have_title("Sample App | へるぷ")
    end

    it "/about には 'あばうと' という言葉が含まれる" do
      visit '/static_pages/about'
      expect(page).to have_content('あばうと')
    end

    it "/about は以下のtitleを保有する" do
      visit '/static_pages/about'
      expect(page).to have_title("Sample App | あばうと")
    end
  end
end
