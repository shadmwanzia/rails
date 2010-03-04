require 'isolation/abstract_unit'

module ApplicationTests
  class UrlGenerationTest < Test::Unit::TestCase
    include ActiveSupport::Testing::Isolation

    def app
      Rails.application
    end

    test "it works" do
      boot_rails
      require "rails"
      require "action_controller/railtie"

      class MyApp < Rails::Application
        config.action_dispatch.session = { :key => "_myapp_session", :secret => "3b7cd727ee24e8444053437c36cc66c4" }
      end

      MyApp.initialize!

      class ::ApplicationController < ActionController::Base
      end

      class ::OmgController < ::ApplicationController
        def index
          render :text => omg_path
        end
      end

      MyApp.routes.draw do
        match "/" => "omg#index", :as => :omg
      end

      require 'rack/test'
      extend Rack::Test::Methods

      get "/"
      assert_equal "/", last_response.body
    end
  end
end
