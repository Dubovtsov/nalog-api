class CompaniesController < ApplicationController
  NALOG_API_KEY = ENV['API_KEY']
  require 'cgi'

  def index
    # @company_data ||= []
  end

  def search
    encoded_query = CGI.escape(params[:inn])
    url = "https://api-fns.ru/api/search?q=#{encoded_query}&key=#{NALOG_API_KEY}"
    response = HTTParty.get(url)

    @result = response.parsed_response
    respond_to do |format|
      if response["items"].any?
        format.turbo_stream
      else
        format.html { redirect_to root_path, alert: "Не удалось найти данные об организации с ИНН #{params[:inn]}" }
      end
    end
  end

  private

  def company_params
    params.require(:company).permit(:inn)
  end
end
