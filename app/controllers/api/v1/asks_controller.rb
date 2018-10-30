class Api::V1::AsksController < ApplicationController

  def challenge
    if params.has_key?(:challenge)
      render json: {"challenge": params[:challenge]}
      return
    end

    if params['event']['type'] == 'app_mention'

      # Book a meeting
      if params['event']['text'].strip.downcase.match(/book (?:me\s)a meeting (for\s)?(today|this morning|this afternoon|tomorrow|tomorrow morning|tomorrow afternoon)/)
        render json: {"answer": "ok, booked!"}

      # Is there a room free right now?
      elsif params['event']['text'].strip.downcase.match(/(?:is there a|what) (?:conference\s|meeting\s)?rooms? (?:are\s)*(?:free|available|open) (?:now|right now|at the moment)/)
        render json: {"answer": "nah, everything's full"}

      # When is Person X's next free slot?
    elsif params['event']['text'].strip.downcase.match(/when is @(\w+) (?:free|available|open) next/)
        given_user = params['event']['text'].strip.downcase.match(/when is @(\w+) (?:free|available|open) next/)[1]
        render json: {"answer": "checking @#{given_user}'s availability"}

      end

    end

  end

end
