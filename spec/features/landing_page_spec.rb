require 'rails_helper'

describe "Viewing the landing page" do
  it "displays title" do
    visit root_url

    expect(page).to have_text("AlchemyData News")
  end
end
