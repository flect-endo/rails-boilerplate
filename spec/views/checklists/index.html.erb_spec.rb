require 'rails_helper'

RSpec.describe "checklists/index", type: :view do
  before(:each) do
    assign(:checklists, [
      Checklist.create!(
        :title => "Title"
      ),
      Checklist.create!(
        :title => "Title"
      )
    ])
  end

  it "renders a list of checklists" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end
end
