class ApplicationController < ActionController::Base
  helper_method :accounts, :active_tab?
  
  def accounts
    @accounts ||= Account.order(:account_type, :name).all
  end

  def active_tab?(test_path)
    "active" if request.path == test_path
  end
end
