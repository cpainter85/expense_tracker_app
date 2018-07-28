class AccountsController < ApplicationController
  def index
    @accounts = Account.order(:account_type, :name).group_by(&:account_type)
  end

  def show
    @account = Account.find(params[:id])
  end
  
  def new
    @account = Account.new
  end
  
  def create
    @account = Account.new(account_params)
    
    if @account.save
      redirect_to accounts_path, notice: "#{@account.name} was successfully added to your accounts"
    end
  end

  def edit
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])
    if @account.update(account_params)
      redirect_to accounts_path, notice: "#{@account.name} was successfully updated"
    end
  end
  
  private
  
  def account_params
    params.require(:account).permit(:name, :account_type, :enabled, :credit_limit)
  end
end