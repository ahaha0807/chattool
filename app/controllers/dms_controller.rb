class DmsController < ApplicationController

  before_action :move_to_index, except: :index


  def index
    @comments = Dm.where(opponent: params[:id]).where(contributor: current_useraccount.id)
    @comment = Dm.new
    @accounts = Useraccount.all
    @account = Useraccount.find(params[:id])
  end

  def create
    Dm.create(comment: comment_params[:comment], contributor: current_useraccount.id, opponent: params[:opponent])
    @comments = Dm.where(opponent: params[:opponent]).where(contributor: current_useraccount.id)
    # binding.pry
  end

  def destroy
    Dm.find(params[:id]).destroy
    @comments = Dm.where(opponent: params[:id]).where(contributor: current_useraccount.id)
    binding.pry
  end

  private
  def comment_params
    params.require(:dm).permit(:comment)
  end

  def move_to_index
    redirect_to action: :index unless useraccount_signed_in?
  end
end
