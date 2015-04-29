require 'spec_helper'

feature "Admin sees payment" do
  background do
    alice = Fabricate(:user, full_name: "Alice Wonderland", email: "alice@example.com")
    Fabricate(:payment, amount: 999, user: alice)
  end
  scenario "admin can see payments" do
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content "Alice Wonderland"
    expect(page).to have_content "alice@example.com"
    expect(page).to have_content "$9.99"
  end

  scenario "user cannot see payments" do
    sign_in(Fabricate(:user))
    visit admin_payments_path
    expect(page).not_to have_content "Alice Wonderland"
    expect(page).not_to have_content "alice@example.com"
    expect(page).to have_content "You are not authorized to do that."
  end
end