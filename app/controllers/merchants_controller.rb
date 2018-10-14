class MerchantsController < ApplicationController
  def autocomplete
    render json: Activity.merchant_autocomplete(term: params[:term])
  end
end