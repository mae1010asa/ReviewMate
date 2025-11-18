class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_q


  protected

  def after_sign_in_path_for(resource)
    mypage_path(resource)
  end

  def after_sign_up_path_for(resource)
    mypage_path(resource)
  end

  def after_sign_out_path_for(resource)
    homes_about_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email,:name])
  end

  private

  def set_q
    @q = Item.ransack(params[:q])
    @items = @q.result(distinct: true)
    @result = params[:q]&.values&.reject(&:blank?)
  end

end
