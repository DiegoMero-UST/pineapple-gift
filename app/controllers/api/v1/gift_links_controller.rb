class Api::V1::GiftLinksController < ApplicationController
  before_action :set_gift_link, only: [:show, :destroy]
  
  # GET /gift_links
  def index
    @gift_links = GiftLink.order(created_at: :desc)
    render json: @gift_links.map { |link| 
      {
        id: link.id,
        token: link.token,
        used: link.used,
        created_at: link.created_at,
        submission: link.submission ? {
          first_name: link.submission.first_name,
          last_name: link.submission.last_name,
          email: link.submission.email,
          prize_name: link.submission.prize.name,
          submitted_at: link.submission.created_at
        } : nil
      }
    }
  end
  
  # GET /gift_links/:id
  def show
    render json: {
      id: @gift_link.id,
      token: @gift_link.token,
      used: @gift_link.used,
      created_at: @gift_link.created_at,
      submission: @gift_link.submission ? {
        first_name: @gift_link.submission.first_name,
        last_name: @gift_link.submission.last_name,
        email: @gift_link.submission.email,
        prize_name: @gift_link.submission.prize.name,
        submitted_at: @gift_link.submission.created_at
      } : nil
    }
  end
  
  # POST /gift_links
  def create
    # Generate a unique token if not provided
    token = params[:token] || SecureRandom.urlsafe_base64(32)
    
    @gift_link = GiftLink.new(token: token)
    
    if @gift_link.save
      render json: {
        id: @gift_link.id,
        token: @gift_link.token,
        used: @gift_link.used,
        created_at: @gift_link.created_at,
        url: "http://localhost:3001/#{@gift_link.token}"
      }, status: :created
    else
      render json: { errors: @gift_link.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /gift_links/:id
  def destroy
    @gift_link.destroy
    head :no_content
  end
  
  private
  
  def set_gift_link
    @gift_link = GiftLink.find(params[:id])
  end
  
  def gift_link_params
    params.permit(:token)
  end
end
