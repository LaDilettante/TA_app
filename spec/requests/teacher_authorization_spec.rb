require 'spec_helper'

describe "Teacher" do
  let(:teacher) { FactoryGirl.create(:teacher) }
  let(:student) { FactoryGirl.create(:student) }
  let(:assignment) { FactoryGirl.create(:assignment) }
  let(:deadline_string) { "03/22/2014 08:00" }
  before { sign_in teacher }

  subject { page }

  describe "can visit student edit page" do
    before { visit edit_user_path(student) }
    it { should have_title "Edit user" }
  end

  describe "can delete student" do
    before do
      visit edit_user_path(student)
      click_link "Delete account (careful!)"
    end

    specify { expect(User.where(email: student.email)).not_to exist }
  end

  describe "can create new assignment" do
    before { visit new_assignment_path }
    let(:submit) { "Post assignment" }

    before { fill_in "Deadline", with: deadline_string } 
    # A kludge to make sure that this date format is right, thus
    # does not raise invalid date error

    describe "but with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(Assignment, :count)
      end

      describe "after submission" do
        before { click_button submit }
        it { should have_title('New assignment') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Title",        with: "Example Title"
        fill_in "Deadline",     with: deadline_string
        attach_file "Document", Rails.root + "spec/fixtures/documents/lab1.pdf"
        attach_file "Source code", Rails.root + "spec/fixtures/documents/lab1.tex"
      end

      it "should create an assignment" do
        expect { click_button submit }.to change(Assignment, :count).by(1)
      end
    end
  end

  describe "can edit assignment" do
    before { visit edit_assignment_path(assignment) }
    before { fill_in "Deadline", with: deadline_string } 
    # A kludge to make sure that this date format is right, thus
    # does not raise invalid date error

    describe "but with invalid information" do
      before do
        fill_in "Title", with: ""
        click_button "Save changes"
      end
      
      it { should have_title("Edit assignment") }
      it { should have_content("error") }
    end

    describe "with valid information" do
      let(:new_title) { "New title" }
      let(:new_body) { "The new body of this assignment" }
      
      before do
        visit edit_assignment_path(assignment)
        fill_in "Title",           with: new_title
        fill_in "Body",            with: new_body
        fill_in "Deadline",        with: deadline_string
        click_button "Save changes"
      end

      it { should have_title(new_title) }
      it { should have_selector('div.alert.alert-success') }
      specify { expect(assignment.reload.title).to eq new_title }
      specify { expect(assignment.reload.body). to eq new_body }
    end
  end
end
