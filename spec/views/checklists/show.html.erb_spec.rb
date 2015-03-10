require 'rails_helper'

RSpec.describe "checklists/show", type: :view do
  before(:each) do
    @checklist = assign(:checklist, Checklist.create!(
      :title => "Title"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
  end
end
