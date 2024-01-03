require 'rails_helper'

RSpec.describe 'transactions page', type: :system do
  before do 
    Transaction.create(amount: 100.01, description: 'credit transaction', date: DateTime.yesterday)
    Transaction.create(amount: -50.1, description: 'debit transaction', date: DateTime.now)
  end

  describe 'index' do
    it 'shows the static text' do
      visit transactions_path

      expect(page).to have_content('Transactions')
      expect(page).to have_content('Amount')
      expect(page).to have_content('Description')
      expect(page).to have_content('Date')
    end

    it 'shows all transactions' do
      visit transactions_path

      transaction_first = Transaction.first
      expect(page).to have_selector("tr#transaction_#{transaction_first.id} td", text: '100.01')
      expect(page).to have_selector("tr#transaction_#{transaction_first.id} td", text: 'credit transaction')
      expect(page).to have_selector("tr#transaction_#{transaction_first.id} td", text: DateTime.yesterday.strftime('%Y-%m-%d'))
      expect(page).to have_selector("tr#transaction_#{transaction_first.id} td", text: 'Show')
      expect(page).to have_selector("tr#transaction_#{transaction_first.id} td", text: 'Edit')
      expect(page).to have_selector("tr#transaction_#{transaction_first.id} td", text: 'Destroy')

      transaction_last = Transaction.last
      expect(page).to have_selector("tr#transaction_#{transaction_last.id} td", text: '-50.1')
      expect(page).to have_selector("tr#transaction_#{transaction_last.id} td", text: 'debit transaction')
      expect(page).to have_selector("tr#transaction_#{transaction_last.id} td", text: DateTime.now.strftime('%Y-%m-%d'))
      expect(page).to have_selector("tr#transaction_#{transaction_last.id} td", text: 'Show')
      expect(page).to have_selector("tr#transaction_#{transaction_last.id} td", text: 'Edit')
      expect(page).to have_selector("tr#transaction_#{transaction_last.id} td", text: 'Destroy')
    end

    it 'redirects to new transaction page' do
      visit transactions_path

      expect(page).to have_link('New transaction', href: new_transaction_path)

      click_link 'New transaction'
      expect(page).to have_selector('h1', text: 'New transaction')
    end

    it 'redirects to show transaction page' do
      visit transactions_path

      transaction = Transaction.first
      click_link 'Show', href: transaction_path(transaction.id)
      expect(page).to have_selector('h1', text: "Show transaction #{transaction.id}")
    end

    it 'redirects to edit transaction page' do
      visit transactions_path

      transaction = Transaction.first
      click_link 'Edit', href: edit_transaction_path(transaction.id)
      expect(page).to have_selector('h1', text: "Editing transaction #{transaction.id}")
    end

    it 'deletes transaction' do
      visit transactions_path

      transaction = Transaction.first
      click_link 'Destroy', href: transaction_path(transaction.id)
      expect(Transaction.count).to eq(1)
      expect(Transaction.first.description).to eq('debit transaction')
    end
  end

  it 'creates new transaction' do
    visit new_transaction_path

    fill_in 'Amount', with: '3.59'
    fill_in 'Description', with: 'Another credit transactions'
    fill_in 'Date', with: DateTime.yesterday.strftime('%Y-%m-%d')

    click_button 'Create Transaction'

    expect(Transaction.count).to eq(3)
    expect(Transaction.last.amount.to_s).to eq('3.59')
    expect(Transaction.last.description).to eq('Another credit transactions')
    expect(Transaction.last.date.strftime('%Y-%m-%d')).to eq(DateTime.yesterday.strftime('%Y-%m-%d'))
  end

  it 'shows the transaction' do
    transaction = Transaction.first
    visit transaction_path(transaction.id)
    
    expect(page).to have_selector('h1', text: "Show transaction #{transaction.id}")

    expect(page).to have_selector('p', text: '100.01')
    expect(page).to have_selector('h5', text: 'credit transaction')
    expect(page).to have_selector('p', text: DateTime.yesterday.strftime('%Y-%m-%d'))
  end

  it 'updates the transaction' do
    visit edit_transaction_path(Transaction.first.id)

    expect(page).to have_selector("input[value='100.01']")
    expect(page).to have_selector("textarea", text: 'credit transaction')
    expect(page).to have_selector("input[value='#{DateTime.yesterday.strftime('%Y-%m-%d')}']")

    fill_in 'Amount', with: '23.59'
    fill_in 'Description', with: 'Changed credit transactions'
    fill_in 'Date', with: DateTime.now.strftime('%Y-%m-%d')

    click_button 'Update Transaction'

    expect(Transaction.first.amount.to_s).to eq('23.59')
    expect(Transaction.first.description).to eq('Changed credit transactions')
    expect(Transaction.first.date.strftime('%Y-%m-%d')).to eq(DateTime.now.strftime('%Y-%m-%d'))
  end
end