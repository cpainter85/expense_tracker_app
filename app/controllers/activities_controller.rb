class ActivitiesController < ApplicationController
  def new
    @account = Account.find(params[:account_id])
    @activity = @account.activities.new
  end

  def create
    @account = Account.find(params[:account_id])
    @activity = @account.activities.new(activity_params)

    if @activity.save
      sleep(1)
      redirect_to account_path(@account), notice: "Activity on #{@activity.transaction_date} for #{@activity.amount} sucessfully added to account"
    else
      flash.now[:error] = "Something went wrong"
      render :new
    end
  end

  def edit
    @account = Account.find(params[:account_id])
    @activity = @account.activities.find(params[:id])
  end

  def update
    @account = Account.find(params[:account_id])
    @activity = @account.activities.find(params[:id])
    if @activity.update(activity_params)
      sleep(1)
      redirect_to account_path(@account), notice: "Activity on #{@activity.transaction_date} for #{@activity.amount} sucessfully updated"
    else
      flash.now[:error] = "Something went wrong"
      render :edit
    end
  end

  def destroy
    @account = Account.find(params[:account_id])
    @activity = @account.activities.find(params[:id])

    if @activity.destroy
      sleep(1)
      redirect_to account_path(@account), notice: "Activity on #{@activity.transaction_date} for #{@activity.amount} sucessfully deleted"
    end
  end

  private

  def activity_params
    params.require(:activity).permit(
      :account_id,
      :transaction_date,
      :merchant,
      :description,
      :cleared,
      :category_id,
      :amount
    )
  end
end