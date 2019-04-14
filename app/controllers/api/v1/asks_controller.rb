class Api::V1::AsksController < ApplicationController

  def challenge
    if params.has_key?(:challenge)
      render json: {"challenge": params[:challenge]}
      return
    end

    inputs = {
      "book_meeting": (/book (?:me\s)a meeting (?:with (?<attendees>(?:@\w+(?:,|\s|&|and)+)+))?(?:(?:about|on)\s(?<topic>.+)\s)?(?<when>today|this morning|this afternoon|tomorrow afternoon|tomorrow morning|tomorrow)/),
      "room_free_now": /(?:is there a|what) (?:conference\s|meeting\s)?rooms? (?:are\s)*(?:free|available|open) (?:now|right now|at the moment)/,
      "person_next_free_when": /when is @(\w+) (?:free|available|open) next/
    }

    if params['event']['type'] == 'app_mention'

      # Book a meeting
      if params['event']['text'].strip.downcase.match(inputs[:book_meeting])
        matches = params['event']['text'].strip.downcase.match(inputs[:book_meeting])
        m_a = matches[:attendees].split(/[,]*\s(and|&)?>\s?/).map {|x| x.strip}
        render json: {"answer": "ok, booked a meeting about #{matches[:topic].strip} for #{matches[:when].strip} with #{m_a.join(', ')}!"}

      # Is there a room free right now?
    elsif params['event']['text'].strip.downcase.match(inputs[:room_free_now])
        render json: {"answer": "nah, everything's full"}

      # When is Person X's next free slot?
    elsif params['event']['text'].strip.downcase.match(inputs[:person_next_free_when])
        given_user = params['event']['text'].strip.downcase.match(inputs[:person_next_free_when])[1]
        render json: {"answer": "checking @#{given_user}'s availability"}

      end

    end

  end

end
