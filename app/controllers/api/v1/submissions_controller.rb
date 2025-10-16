class Api::V1::SubmissionsController < ApplicationController
  before_action :set_gift_link, only: [:create, :show, :form_data]
  
  # GET /gift_links/:token/submission
  def show
    if @gift_link.submission
      render json: {
        submitted: true,
        message: "Thanks for picking your prize!",
        submission: {
          first_name: @gift_link.submission.first_name,
          last_name: @gift_link.submission.last_name,
          email: @gift_link.submission.email,
          prize_name: @gift_link.submission.prize.name,
          submitted_at: @gift_link.submission.created_at
        }
      }
    else
      render json: {
        submitted: false,
        message: "Please select your prize and fill out the form."
      }
    end
  end
  
  # GET /gift_links/:token/form_data
  def form_data
    if @gift_link.used?
      render json: {
        error: "This gift link has already been used",
        submitted: true,
        message: "Thanks for picking your prize!"
      }
      return
    end
    
    # Get available prizes for the form
    prizes = Prize.all.map { |prize|
      {
        id: prize.id,
        name: prize.name,
        description: prize.description
      }
    }
    
    render json: {
      submitted: false,
      token: @gift_link.token,
      prizes: prizes,
      form_fields: {
        required: [:first_name, :last_name, :email, :address1, :city, :state, :country, :zip, :prize_id],
        optional: [:address2]
      }
    }
  end
  
  # POST /gift_links/:token/submission
  def create
    if @gift_link.used?
      render json: { 
        error: "This gift link has already been used",
        submitted: true,
        message: "Thanks for picking your prize!"
      }, status: :unprocessable_entity
      return
    end
    
    @submission = @gift_link.build_submission(submission_params)
    
    if @submission.save
      render json: {
        submitted: true,
        message: "Thanks for picking your prize!",
        submission: {
          first_name: @submission.first_name,
          last_name: @submission.last_name,
          email: @submission.email,
          prize_name: @submission.prize.name,
          submitted_at: @submission.created_at
        }
      }, status: :created
    else
      render json: { 
        errors: @submission.errors.full_messages,
        field_errors: @submission.errors.messages,
        submitted: false,
        message: "Please fix the errors and try again."
      }, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_gift_link
    @gift_link = GiftLink.find_by!(token: params[:token])
  end
  
  def submission_params
    params.require(:submission).permit(
      :first_name, :last_name, :email, :address1, :address2, 
      :city, :state, :country, :zip, :prize_id
    )
  end
end
