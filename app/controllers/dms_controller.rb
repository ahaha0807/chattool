class DmsController < ApplicationController

  before_action :move_to_index, except: :index

  def index
    @comments = extraction_index
    @comment = Dm.new
    @accounts = Useraccount.all
    @account = Useraccount.find(params[:id])
    @groups = Group.all    
  end

  def create
    Dm.create(comment_params)

    @comments = extraction_create
  end

  def destroy
    @comments = extraction_destroy
    Dm.find(params[:id]).destroy
  end

  private
  def comment_params
    params.require(:dm).permit(:comment).merge(contributor: current_useraccount.id, opponent: params[:opponent])
  end

  def extraction_index
    Dm.where('opponent = ? OR opponent = ?', params[:id], current_useraccount.id).where('contributor = ? OR contributor = ?', params[:id], current_useraccount.id)
  end

  def extraction_create
    Dm.where('opponent = ? OR opponent = ?', params[:opponent], current_useraccount.id).where('contributor = ? OR contributor = ?', params[:opponent], current_useraccount.id)
  end

  def extraction_destroy
    comment = Dm.find(params[:id])
    Dm.where('opponent = ? OR opponent = ?', comment.opponent, current_useraccount).where('contributor = ? OR contributor = ?', comment.opponent, current_useraccount)
  end

  def move_to_index
    redirect_to action: :index unless useraccount_signed_in?
  end
end
