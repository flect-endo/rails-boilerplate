require 'rails_helper'

RSpec.describe "checklists/new", type: :view do
  before(:each) do
    assign(:checklist, Checklist.new(
      :title => "MyString"
    ))
  end

  it "renders new checklist form" do
    render

    assert_select "form[action=?][method=?]", checklists_path, "post" do

      assert_select "input#checklist_title[name=?]", "checklist[title]"
    end
  end
end
