class MainController < ApplicationController
  before_action :sidebar
  def index
    # TODO: Implement pagination
    @articles = Article.all_published.order(:publish_by).page(1).per(10)
    puts @articles.inspect
  end

  def categories
    # TODO: Implement pagination
    @categories = Category.all
  end

  def search
    if params[:query].present?
      # Implements fuzzy search
      # TODO: Implement pagination
      @articles = Article.where('(publish_by is not null and publish_by <= :now) AND (title LIKE :search OR content LIKE :search)', now: DateTime.now, search: params[:query])
    end
  end

  def category
    # TODO: Implement published only querying
    unless params[:id].present?
      redirect_back_or_to :categories
      return
    end

    @category = Category.find_by id: params[:id]
    unless @category.present?
      redirect_back_or_to :categories
    end
  end

  def article
    unless params[:id].present?
      redirect_back_or_to :root
      return
    end

    @article = Article.find_by id: params[:id]
    unless @article.present?
      redirect_back_or_to :root
    end
  end

  protected

  def sidebar
    @sidebar_comments
    @sidebar_categories
  end

  # Also sets the valid current page
  def load_pagination(page: 1, max_page: 1)

  end
end
