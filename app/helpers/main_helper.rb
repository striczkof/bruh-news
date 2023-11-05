module MainHelper
  def active_class(path)
    request.path == path ? 'active' : ''
  end

  def list_article_categories(categories: nil, capitalise: true)
    if categories.present?
      category_names = []

    end
  end


end
