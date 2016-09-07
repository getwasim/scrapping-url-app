module Api
  module V1
    class PagesController < ApplicationController
      skip_before_filter :verify_authenticity_token, only: [:save_url_data]
      
      # GET /api/v1/pages.json
      # To get list of all the pages
      def index
        @pages = Page.all
        render json: @pages, status: 200
      end

      # POST /api/v1/pages/save_url_data.json
      # To save page details of given URl
      def save_url_data
        @page = Page.find_or_initialize_by(url: params[:url])

        begin
          fetch_website_details(params[:url])
          if @page.save
            render json: {success: true, data: {page: @page} }, status: 200
          else
            render json: {success: false, error: 'Something went wrong. We are not able to save your details. Try again later.'}, status: 422
          end
        rescue HTTParty::Error
          render json: {success: false, error: 'Issue while fetching the content. Try again later.'}, status: 500
        rescue Exception => e
          render json: {success: false, error: 'Invalid parameters. Please enter valid URL.'}, status: 400
        end
      end

      private
        def fetch_website_details url
          response = HTTParty.get(url)
          body = Nokogiri::HTML(response.body)

          tags = ['h1', 'h2', 'h3', 'link']
          tags.each do |html_tag|
            tag_values = []
            body.css(html_tag).map do |node|
              tag_values << case html_tag
                            when 'link'
                              node['href']
                            else
                              node.text
                            end
            end
            @page.send "#{html_tag}=".to_sym, tag_values
          end
        end

    end
  end
end