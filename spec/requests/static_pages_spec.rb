require 'spec_helper'

describe "StaticPages" do
    let(:base_title) { "Sample App | " }
    let(:v_home) {visit '/static_pages/home'}
    let(:v_help) {visit '/static_pages/help'}
    let(:v_about) {visit '/static_pages/about'}
    let(:v_contact) {visit '/static_pages/contact'}
  describe "Home page" do

    it "/home には 'ほーむ' という言葉が含まれる" do
      v_home
      expect(page).to have_content('Sample')
    end

    it "/home は以下のtitleを保有する" do
      v_home
      expect(page).to have_title("Sample App")
    end

    it "should not have a custom page title" do
      v_home
      expect(page).not_to have_title('ほーむ')
    end

    it "/help には 'へるぷ' という言葉が含まれる" do
      v_help
      expect(page).to have_content('へるぷ')
    end

    it "/help は以下のtitleを保有する" do
      v_help
      expect(page).to have_title("#{base_title}へるぷ")
    end

    it "/about には 'あばうと' という言葉が含まれる" do
      v_about
      expect(page).to have_content('あばうと')
    end

    it "/about は以下のtitleを保有する" do
      v_about
      expect(page).to have_title("#{base_title}あばうと")
    end

    it "/contact には 'こんたくと' という言葉が含まれる" do
      v_contact
      expect(page).to have_content('こんたくと')
    end

    it "/contact は以下のtitleを保有する" do
      v_contact
      expect(page).to have_title("Sample App | こんたくと")
    end
  end
end
