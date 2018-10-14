class AccountsController < ApplicationController
  def index
  end

  def show
    @account = Account.find(params[:id])

    @response = @account.get_activities(page: params[:page])

    @activities = @response.results.map(&:_source)
    @total_balance = @response.aggregations.total_balance.value
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      redirect_to accounts_path, notice: "#{@account.name} was successfully added to your accounts"
    else
      flash.now[:error] = "Something went wrong"
      render :new
    end
  end

  def edit
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])
    if @account.update(account_params)
      redirect_to accounts_path, notice: "#{@account.name} was successfully updated"
    else
      flash.now[:error] = "Something went wrong"
      render :edit
    end
  end

  private

  def account_params
    params.require(:account).permit(:name, :account_type, :enabled, :credit_limit)
  end
end