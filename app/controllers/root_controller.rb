class RootController < ApplicationController
  def root
    redirect_to podcasts_path
  end
end
