require 'rails_helper'

RSpec.describe "checklists/edit", type: :view do
  before(:each) do
    @checklist = assign(:checklist, Checklist.create!(
      :title => "MyString"
    ))
  end

  it "renders the edit checklist form" do
    render

    assert_select "form[action=?][method=?]", checklist_path(@checklist), "post" do

      assert_select "input#checklist_title[name=?]", "checklist[title]"
    end
  end
end
