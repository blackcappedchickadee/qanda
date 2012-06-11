class RegistrationsController < Devise::RegistrationsController
  def new
    redirect_to static_pages_notactive_path
  end

  def create
    redirect_to static_pages_notactive_path
  end

  def update
    redirect_to static_pages_notactive_path
  end
end
