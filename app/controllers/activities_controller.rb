class ActivitiesController < ApplicationController
  def new
    @account = Account.find(params[:account_id])
    @activity = @account.activities.new
  end

  def create
    @account = Account.find(params[:account_id])
    @activity = @account.activities.new(activity_params)

    if @activity.save
      redirect_to account_path(@account), notice: "Activity on #{@activity.transaction_date} for #{@activity.amount} sucessfully added to account"
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