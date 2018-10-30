class Api::V1::AsksController < ApplicationController

  def challenge
    if params.has_key?(:challenge)
      render json: {"challenge": params[:challenge]}
    else
      render json: {"yo": "hey"}
    end
  end

end
