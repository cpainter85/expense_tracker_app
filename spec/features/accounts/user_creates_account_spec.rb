require "rails_helper"

feature "User create account" do
  scenario "with valid input" do
    visit accounts_path
    click_link "Add new account"
    
    fill_in "Name", with: "My Credit Card"
    select("Credit Card", from: "Account type")
    fill_in "Credit limit", with: "10000"
    check("Enabled")

    click_button "Create Account"

    expect(page).to have_content "My Credit Card was successfully added to your accounts"
  end
end