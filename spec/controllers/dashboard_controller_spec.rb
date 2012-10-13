require 'spec_helper'

describe DashboardController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'starred'" do
    it "returns http success" do
      get 'starred'
      response.should be_success
    end
  end

end
