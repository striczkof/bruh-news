module AccountHelper
  ## Disable button when a success flash is present
  def input_disabled_class
    @redirect_out ? 'disabled' : ''
  end

  def form_disabled?
    @redirect_out.present? ? @redirect_out : false
  end

  def redirect_out_when_requested
    if @redirect_out

    end
  end
end
