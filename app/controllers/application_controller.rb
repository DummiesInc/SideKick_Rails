class ApplicationController < ActionController::API
    def index
        render json: {"hello": "hello"}
    end
end
