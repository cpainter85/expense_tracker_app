require "rails_helper"

feature "User updates account" do
  scenario "with valid input" do
    account = create(:account)

    visit accounts_path
    find_link(href: edit_account_path(account)).click
    
    uncheck("Enabled")
    click_button "Update Account"

    expect(page).to have_content "#{account.name} was successfully updated"
  end
end