require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end
        it { should have_link('delete', href: user_path(User.first)) }
        it { should_not have_link('delete', href: user_path(admin)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
      end
    end
  end
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_content(user.email) }
    it { should have_title(user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
  end

  describe "signup page" do
      before { visit signup_path }

      it{ should have_content('Sign up') }
      it{ should have_title(full_title('Sign up')) }
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end


    describe "after submission" do
      let(:n_blank) { '* Name can\'t be blank' }
      let(:n_long) { '* Name is too long (maximum is 30 characters)' }
      let(:e_blank) { '* Email can\'t be blank' }
      let(:e_invalid) { '* Email is invalid' }
      let(:pass_short) { '* Password is too short (minimum is 6 characters)' }
      let(:pass_blank) { '* Password can\'t be blank' }
      let(:pass_miss_match) { '* Password confirmation doesn\'t match Password' }
      let(:pass_short) { '* Password is too short (minimum is 6 characters)' }

      describe "A pattern" do
        before do
          fill_in "Name",         with: ""
          fill_in "Email",        with: ""
          fill_in "Password",     with: ""
          fill_in "Confirmation", with: ""
          click_button submit
        end
        it { should have_title('Sign up') }
        it { should have_content('The form contains 5 errors') }
        it { should have_content(n_blank) }
        it { should have_content(e_blank) }
        it { should have_content(e_invalid) }
        it { should have_content(pass_short) }
        it { should have_content(pass_blank) }
      end

      describe "B pattern" do
        before do
          fill_in "Name",         with: "a" * 31
          click_button submit
        end
        it { should have_title('Sign up') }
        it { should have_content('The form contains 5 errors') }
        it { should have_content(n_long) }
      end

      describe "C pattern" do
        before do
          fill_in "Password",     with: "aaaaaaaaaa"
          fill_in "Confirmation", with: "bbbbbbbbbb"
          click_button submit
        end
        it { should have_title('Sign up') }
        it { should have_content('The form contains 4 errors') }
        it { should have_content(pass_miss_match) }
      end

      describe "D pattern" do
        before do
          fill_in "Password",     with: "foo"
          fill_in "Confirmation", with: "foo"
          click_button submit
        end
        it { should have_title('Sign up') }
        it { should have_content('The form contains 4 errors') }
        it { should have_content(pass_short) }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end

    describe "after saving the user" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobaraaa"
        fill_in "Confirmation", with: "foobaraaa"
        click_button submit
      end
      let(:user) { User.find_by(email: 'user@example.com') }

      it { should have_link('Sign out') }
      it { should have_title(user.name) }
      it { should have_selector('div.alert.alert-success', text: '入力お疲れさまです。無事に登録されました。') }

      describe "reload show page" do
        before{ visit "/users/#{user.id}" }
        it { should_not have_selector('div.alert.alert-success', text: '入力お疲れさまです。無事に登録されました。') }
      end

      describe "visit signup page" do
        before{ visit "/signup" }
        it { should_not have_title('Sign up') }
        it { should have_content('hogehoge') }
      end

    end
  end

    describe "edit" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        visit edit_user_path(user)
      end

      describe "edit page" do
        it { should have_content("Update your profile") }
        it { should have_title("Edit user") }
        it { should have_link('change', href: 'http://gravatar.com/emails') }
      end

      describe "with invalid information" do
        before { click_button "Save changes" }

        it { should have_content('error') }
      end
      describe "with valid information" do
        let(:new_name)  { "New Name" }
        let(:new_email) { "new@example.com" }
        before do
          fill_in "Name",             with: new_name
          fill_in "Email",            with: new_email
          fill_in "Password",         with: user.password
          fill_in "Confirmation", with: user.password
          click_button "Save changes"
        end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      it { expect(user.reload.name).to  eq new_name }
      it { expect(user.reload.email).to eq new_email }
    end
  end

  describe "forbidden attributes" do
    let(:user) { FactoryGirl.create(:user) }
    let(:params) do
      { user: { admin: true,
                password: user.password,
                password_confirmation: user.password } }
    end
    before do
      sign_in user, no_capybara: true
      patch user_path(user), params
    end
    specify { expect(user.reload).not_to be_admin }
  end
end
