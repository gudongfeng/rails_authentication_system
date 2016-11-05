class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :validate_user, except: [:index]

  wechat_api

  def index
    # flash[:notice] = t :flash
  end
end
