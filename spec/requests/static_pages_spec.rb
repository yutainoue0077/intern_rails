require 'spec_helper'
describe "StaticPages" do
    let(:base_title) { "Sample App | " }
    subject{ page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('Sample') }
    it { should have_title(full_title('')) }
    it { should_not have_title('ほーむ') }
  end

  describe "Help page" do
    before { visit help_path }
    it { should have_content('へるぷ') }
    it { should have_title(full_title('へるぷ')) }
  end

  describe "About page" do
    before { visit about_path }
    it { should have_content('あばうと') }
    it { should have_title(full_title('あばうと')) }
  end

  describe "Contact page" do
    before { visit contact_path }
    it { should have_content('こんたくと') }
    it { should have_title(full_title('こんたくと')) }
  end
end
