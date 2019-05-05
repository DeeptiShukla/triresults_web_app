module Api
  class RacesController < ApplicationController
    protect_from_forgery with: :null_session
    rescue_from Mongoid::Errors::DocumentNotFound do |exception|
      if !request.accept || request.accept == "*/*"
        render plain: "woops: cannot find race[#{params[:id]}]", status: :not_found
      else
        render :template=>"api/error_msg",:locals=>{ :msg=>"woops: cannot find race[#{params[:id]}]"},:status=>:not_found
      end
    end

    rescue_from ActionView::MissingTemplate do |exception|
      Rails.logger.debug exception
      render :status => :unsupported_media_type,
             plain: "woops: we do not support that content-type[#{request.accept}]"
    end

    def index
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races, offset=[#{params[:offset]}], limit=[#{params[:limit]}]"
      else
        #real implementation ...
      end
    end

    def show
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:id]}"
      elsif request.accept.include?("application/xml") || request.accept.include?("application/json")
	 	    race = Race.find(params[:id])
        if(race.present?)
       		render :status=>:ok,
             		 :content_type => request.accept,
                 :locals=>{race: race}
        end
      end
    end

    def create
      if !request.accept || request.accept == "*/*"
        render plain: "#{params[:race][:name]}", status: :ok
      else
        race = Race.create(race_params)
        render plain: race.name, status: :created
      end
    end

    def update
      # Rails.logger.debug("method=#{request.method}")
      race = Race.find(params[:id])
      race.update(update_params)
      render json: race
    end

    def destroy
      Race.find(params[:id]).destroy
      render :nothing=>true, :status => :no_content
    end

    private

    def race_params
      params.require(:race).permit(:name, :date)
    end

    def update_params
      race_params
    end
  end
end
