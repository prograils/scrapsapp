require 'spec_helper'

describe OrganizationsController do
  render_views

  # This should return the minimal set of attributes required to create a valid
  # Organization. As you add validations to Organization, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    FactoryGirl.attributes_for(:organization)
  end

  before(:each) do
    login_user
    @user = User.first
  end


  describe "GET index" do
    it "assigns all possible organizations as @organizations" do
      organization = Organization.create! valid_attributes
      organization.make_user(@user)
      get :index, {}
      assigns(:organizations).should eq([organization])
    end

  end

  describe "GET show" do
    it "assigns the requested organization as @organization" do
      organization = Organization.create! valid_attributes
      get :show, {:id => organization.to_param}
      assigns(:organization).should eq(organization)
    end
  end

  describe "GET edit" do
    it "assigns the requested organization as @organization" do
      organization = Organization.create! valid_attributes
      organization.make_admin(@user)
      get :edit, {:id => organization.to_param}
      assigns(:organization).should eq(organization)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "assigns the requested organization as @organization" do
        organization = Organization.create! valid_attributes
        organization.make_admin(@user)
        put :update, {:id => organization.to_param, :organization => {:name=>organization.name}}
        assigns(:organization).should eq(organization)
      end

      it "redirects to the organization" do
        organization = Organization.create! valid_attributes
        organization.make_admin(@user)
        put :update, {:id => organization.to_param, :organization => {:name=>organization.name}}
        response.should redirect_to(organization)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested organization" do
      organization = Organization.create! valid_attributes
      organization.make_admin(@user)
      expect {
        delete :destroy, {:id => organization.to_param}
      }.to change(Organization, :count).by(-1)
    end

    it "redirects to the organizations list" do
      organization = Organization.create! valid_attributes
      organization.make_admin(@user)
      delete :destroy, {:id => organization.to_param}
      response.should redirect_to(organizations_url)
    end
  end

end
