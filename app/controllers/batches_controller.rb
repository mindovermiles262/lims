class BatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_privledges

  def index
    @batches = Batch.all
  end

  def new
    @available_methods = Batch.available_methods
    @tests = Test.where(test_method_id: params[:test_method])
    @batch = Batch.new
    @batch.tests.build
  end
  
  def create
    @batch = Batch.new(batch_params)
    if @batch.save
      flash[:success] = "Batch created"
      # TODO: update batched status
      redirect_to @batch
    else
      flash[:danger] = "Unable to create Batch"
      render :new
    end
  end

  def show
    @batch = Batch.find(params[:id])
  end

  private

  def batch_params
    params.require(:batch).permit(:tests_attributes => [:id, :sample_id, :test_method_id])
  end
  
  def check_user_privledges
    unless current_user && (current_user.admin? || current_user.analyst?)
      flash[:danger] = "Unauthorized"
      redirect_to root_path
    end
  end
end