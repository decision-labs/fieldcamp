class PublicController < ApplicationController
  skip_filter :authenticate_user!
  def index
    # @articles = Article.published.page(params[:page]).per(5)
    # redirect sign_in
  end
end
