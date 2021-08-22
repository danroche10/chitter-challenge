require 'spec_helper'

feature 'authentication' do

  it 'a user can sign in' do
    # Create a test user
    User.create(email: 'test@test.com', password: 'password123', name: 'testname', username: 'username')

    # Then sign in as them
    visit '/'
    click_button('Login')
    fill_in('email', with: 'test@test.com')
    fill_in('password', with: 'password123')
    click_button('Sign in')
    expect(page).to have_content 'Welcome, username'
  end

  scenario 'a user sees an error if they get their email wrong' do
    User.create(email: 'test@test.com', password: 'password123', name: 'testname', username: 'username')
    visit '/'
    click_button('Login')
    fill_in('email', with: 'nottherightemail@me.com')
    fill_in('password', with: 'password123')
    click_button('Sign in')
    
    expect(page).not_to have_content 'Welcome, username' 
    expect(page).to have_content 'Please check your email or password'
  end

  scenario 'a user sees an error if they get their password wrong' do
    User.create(email: 'test@test.com', password: 'password123', name: 'testname', username: 'username')
    visit '/'
    click_button('Login')
    fill_in('email', with: 'test@test.com')
    fill_in('password', with: 'wrong password')
    click_button('Sign in')

    expect(page).not_to have_content 'Welcome, username' 
    expect(page).to have_content 'Please check your email or password'
  end

  scenario 'a user can sign out' do
    User.create(email: 'test@test.com', password: 'password123', name: 'testname', username: 'username')
    visit '/'
    click_button('Login')
    fill_in('email', with: 'test@test.com')
    fill_in('password', with: 'password123')
    click_button('Sign in')
    click_button('Sign out')

    expect(page).not_to have_content 'Welcome, test@example.com'
    page.should_not have_button('Sign out')
  end
end