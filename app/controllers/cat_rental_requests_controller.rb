
class CatRentalRequestsController < ApplicationController

  def approve
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.approve!
    flash[:errors] = @cat_rental_request.errors.full_messages
    redirect_to cat_rental_requests_url
  end

  def deny
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.deny
    flash[:errors] = @cat_rental_request.errors.full_messages
    redirect_to cat_rental_requests_url
  end

  def index
    render :index
  end

  def new
    @cat_rental_request = CatRentalRequest.new
    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(rental_params)
    if @cat_rental_request.save
      redirect_to cat_url(@cat_rental_request.cat_id)
    else
      render :new
    end
  end

  def show
  end

  def destroy
  end

  def update
  end

  def all_cat_rental_requests
    CatRentalRequest.all_sorted_by_start_date
  end

  def all_cats
    Cat.all
  end

  helper_method :all_cats, :all_cat_rental_requests

private
  def rental_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end

end
