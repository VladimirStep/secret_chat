class Api::V1::ProfilesController < ApplicationController
  before_action :get_profile

  def create
    profile = current_user.create_profile(profile_params)
    if profile.persisted?
      render json: profile
    else
      render json: { errors: profile.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def show
    if @profile
      render json: @profile
    else
      render json: { error: 'Profile not found' }, status: :not_found
    end
  end

  def update
    if @profile.update_attributes(profile_params)
      render json: @profile
    else
      render json: { errors: @profile.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    @profile.destroy
    render json: { message: 'deleted' }
  end

  private

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :gender)
  end

  def get_profile
    @profile = current_user.profile
  end
end
