## This admin controller has views rendered in
class AdminController < MainController
  include AdminOps
  before_action :authorise

  def index
    if request.post?
      # Handle POST admin ops
      @status = :accepted
      if params[:admin_ops]
        case params[:admin_ops].to_i
        when AdminOps::CREATE_ARTICLE
          create_article params: article_params
        when AdminOps::PUBLISH_ARTICLE
          create_article params: article_params, publish_now: true
        when AdminOps::EDIT_ARTICLE
          edit_article params: article_params
        when AdminOps::EDIT_THEN_PUBLISH_ARTICLE
          edit_article params: article_params, publish_now: true
        when AdminOps::DELETE_ARTICLE
          delete_article params: article_params
        when AdminOps::CREATE_CATEGORY
          create_category params: category_params
        when AdminOps::EDIT_CATEGORY
          edit_category params: category_params
        when AdminOps::DELETE_CATEGORY
          delete_category params: category_params
        else
          # No ops found for some reason, throw an error.
          flash.now[:fail] = FlashCodes::NO_ADMIN_OPS
          @status = :bad_request
        end
      else
        # No ops found for some reason, throw an error.
        flash.now[:fail] = FlashCodes::NO_ADMIN_OPS
        @status = :bad_request
      end
    end
    # Prepare view stuff
    @page_title = 'Admin Panel'
    @categories = Category.all
    @articles_all = Article.all
    @articles_published = Article.all_published
    @articles_hidden = Article.all_hidden
    @article_modals_made = []
    #@categories = @all_categories.page(1)
    render status: @status
  end

  private

  ## Kick the user back to the main page if not an admin.
  def authorise
    unless admin?
      @status = :forbidden
      redirect_back_or_to(:root)
    end
  end

  # Admin operations

  def create_article(params: article_params, publish_now: false)
    @article = Article.new params
    @article.publish_by = DateTime.now if publish_now
    if @article.valid?
      if @article.save
        @status = :created
        flash.now[:success] = FlashCodes::NEW_ARTICLE_YAY
      else
        @status = :not_acceptable
        flash.now[:fail] = FlashCodes::INTERNAL_SERVER_ERROR
      end
    else
      flash.now[:fail] = FlashCodes::INVALID_INPUT
      @status = :not_acceptable
    end
  end

  def edit_article(params: article_params, publish_now: false)
    @article = Article.update params[:id], params
    @article.publish_by = DateTime.now if publish_now && ! @article.published?
    if @article.errors.blank?
      # Success
      @status = :created
      flash.now[:success] = FlashCodes::EDIT_ARTICLE_YAY
    else
      flash.now[:fail] = FlashCodes::INTERNAL_SERVER_ERROR
      @status = :not_acceptable
    end
  end

  def delete_article(params: article_params)
    @article = Article.find_by id: params[:id]
    if @article.blank?
      @status = :not_found
      flash.now[:fail] = FlashCodes::INTERNAL_SERVER_ERROR
    elsif @article.destroy
      @status = :accepted
      flash.now[:success] = FlashCodes::DELETE_ARTICLE_YAY
    else
      @status = :not_acceptable
      flash.now[:fail] = FlashCodes::INTERNAL_SERVER_ERROR
    end
  end

  def create_category(params: category_params)
    @category = Category.new params
    if @category.valid?
      if @category.save
        @status = :created
        flash.now[:success] = FlashCodes::NEW_CATEGORY_YAY
      else
        @status = :not_acceptable
        flash.now[:fail] = FlashCodes::INTERNAL_SERVER_ERROR
      end
    else
      flash.now[:fail] = FlashCodes::INVALID_INPUT
      @status = :not_acceptable
    end
  end

  def edit_category(params: category_params)
    @category = Category.update params[:id], params
    if @category.errors.blank?
      # Success
      @status = :created
      flash.now[:success] = FlashCodes::RENAME_CATEGORY_YAY
    else
      flash.now[:fail] = FlashCodes::INTERNAL_SERVER_ERROR
      @status = :not_acceptable
    end
  end

  def delete_category(params: category_params)
    @category = Category.find_by id: params[:id]
    if @category.blank?
      @status = :not_found
      flash.now[:fail] = FlashCodes::INTERNAL_SERVER_ERROR
    elsif @category.destroy
      @status = :accepted
      flash.now[:success] = FlashCodes::DELETE_CATEGORY_YAY
    else
      @status = :not_acceptable
      flash.now[:fail] = FlashCodes::INTERNAL_SERVER_ERROR
    end
  end

  # Params

  def category_params
    params.require(:category).permit(:id, :name)
  end

  def article_params
    params.require(:article).permit(:id, :author_id, :title, :content, :comments_enabled, :publish_by, category_ids: [])
  end

end
