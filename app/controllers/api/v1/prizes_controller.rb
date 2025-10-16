class Api::V1::PrizesController < ApplicationController
  # GET /prizes
  def index
    @prizes = Prize.all
    render json: @prizes.map { |prize|
      {
        id: prize.id,
        name: prize.name,
        description: prize.description
      }
    }
  end
  
  # GET /prizes/:id
  def show
    @prize = Prize.find(params[:id])
    render json: {
      id: @prize.id,
      name: @prize.name,
      description: @prize.description
    }
  end
end
