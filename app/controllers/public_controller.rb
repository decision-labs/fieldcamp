class PublicController < ApplicationController
  skip_filter :authenticate_user!
  def index
    # @articles = Article.published.paginate(:page => params[:page], :per_page => 5).all
    # redirect sign_in
  end
end
