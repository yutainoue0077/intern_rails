require 'spec_helper'

describe "StaticPages" do
    subject{ page }

  shared_examples_for "all static pages" do
    it { should have_content(title) }
    it { should have_title(full_title(title)) }
    #have_title(full_title(title))
  end

  describe "Home page" do
    before { visit root_path }
    let(:name) {'Sample'}
    let(:title){''}

    it_should_behave_like "all static pages"
    it { should_not have_title('ほーむ') }

  describe "for signed-in users at post 1" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
      sign_in user
      visit root_path
    end
    it { should have_content("1 micropost") }
  end

    describe "for signed-in users at post 2" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end
      it { should have_content("2 microposts") }
      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      it "should render the user's feed" do
        click_button "Post"
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

            describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:name) {'へるぷ'}
    let(:title){'へるぷ'}

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:name) {'あばうと'}
    let(:title){'あばうと'}

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:name) {'こんたくと'}
    let(:title){'こんたくと'}

    it_should_behave_like "all static pages"
  end

    it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('あばうと'))
    click_link "Help"
    expect(page).to have_title(full_title('へるぷ'))
    click_link "Contact"
    expect(page).to have_title(full_title('こんたくと'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title(''))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end
end
