module AdminHelper
  def render_modal(name: '', title: name.underscore, large: false, model: nil)
    model.present? ? id = model.id : ''
    render partial: "admin/modals/#{name.underscore}", locals: {model: model, form_id: "#{name}Form#{id}"}
    render template: 'layouts/admin/modal', locals: {modal_id: "#{name}Modal#{id}", modal_title: title, large_modal: large}
  end
end
