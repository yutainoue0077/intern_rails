require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should paginate the feed（未実装）" do
        40.times { FactoryGirl.create(:micropost, user: user) }
        visit root_path
        page.should_not have_selector('div.pagination')
        Micropost.delete_all
      end

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }
      let(:user_second) { FactoryGirl.create(:user) }
      let(:user) { FactoryGirl.create(:user) }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end

      it "should not delete a your micropost" do

        FactoryGirl.create(:micropost, user: user_second)
        sign_in user
        visit user_path(user_second)
        should_not have_link("delete")
      end
    end
  end
end
