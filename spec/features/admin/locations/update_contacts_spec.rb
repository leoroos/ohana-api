require 'rails_helper'

feature 'Update contacts' do
  background do
    @location = create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'when no contacts exist'  do
    expect(page).
      to have_no_xpath('//input[@id="location_contacts_attributes_0_name"]')

    expect(page).to_not have_link 'Delete this contact permanently'
  end
end

feature 'Update contacts' do
  before(:all) do
    @location = create(:location)
    @location.contacts.create!(name: 'foo', title: 'bar')
  end

  before(:each) do
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  after(:all) do
    Organization.find_each(&:destroy)
  end

  scenario 'with an empty name' do
    skip "Broken"
    update_contact(name: '')
    click_button 'Save changes'
    expect(page).to have_content "name can't be blank for Contact"
  end

  scenario 'with an empty title' do
    skip "Broken"
    update_contact(title: '')
    click_button 'Save changes'
    expect(page).to have_content "title can't be blank for Contact"
  end

  scenario 'with an empty email' do
    skip "Broken"
    update_contact(email: '')
    click_button 'Save changes'
    expect(page).to_not have_content 'is not a valid email'
  end

  scenario 'with an empty phone' do
    skip "Broken"
    update_contact(phone: '')
    click_button 'Save changes'
    expect(page).to_not have_content 'is not a valid US phone number'
  end

  scenario 'with an empty fax' do
    skip "Broken"
    update_contact(fax: '')
    click_button 'Save changes'
    expect(page).to_not have_content 'is not a valid US fax number'
  end

  scenario 'with an invalid email' do
    skip "Broken"
    update_contact(email: '703')
    click_button 'Save changes'
    expect(page).to have_content 'is not a valid email'
  end

  scenario 'with an invalid phone' do
    skip "Broken"
    update_contact(phone: '703')
    click_button 'Save changes'
    expect(page).to have_content 'is not a valid US phone number'
  end

  scenario 'with an invalid fax' do
    skip "Broken"
    update_contact(fax: '202')
    click_button 'Save changes'
    expect(page).to have_content 'is not a valid US fax number'
  end
end
