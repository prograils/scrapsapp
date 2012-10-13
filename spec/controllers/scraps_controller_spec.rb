require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ScrapsController do

  # This should return the minimal set of attributes required to create a valid
  # Scrap. As you add validations to Scrap, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    FactoryGirl.attributes_for(:scrap)
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ScrapsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  login_user
  before(:each) do
    @organization = FactoryGirl.create(:organization)
    @organization.make_user(@user)
  end

  describe "GET index" do
    it "assigns all scraps as @scraps" do
      scrap = Scrap.create! valid_attributes
      scrap.user = @user
      scrap.organization = @organization
      scrap.save
      get :index, {:organization_id=>@organization.id}
      assigns(:scraps).should eq([scrap])
    end
  end

  describe "GET show" do
    it "assigns the requested scrap as @scrap" do
      scrap = Scrap.create! valid_attributes
      scrap.user = @user
      scrap.organization = @organization
      scrap.save
      get :show, {:id => scrap.to_param, :organization_id=>@organization.id}
      assigns(:scrap).should eq(scrap)
    end
  end

  describe "GET new" do
    it "assigns a new scrap as @scrap" do
      get :new, {:organization_id=>@organization.id}
      assigns(:scrap).should be_a_new(Scrap)
    end
  end

  describe "GET edit" do
    it "assigns the requested scrap as @scrap" do
      scrap = Scrap.create! valid_attributes
      scrap.user = @user
      scrap.organization = @organization
      scrap.save
      get :edit, {:id => scrap.to_param, :organization_id=>@organization.id}
      assigns(:scrap).should eq(scrap)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Scrap" do
        expect {
          post :create, {:scrap => valid_attributes, :organization_id=>@organization.id}
        }.to change(Scrap, :count).by(1)
      end

      it "assigns a newly created scrap as @scrap" do
        post :create, {:scrap => valid_attributes, :organization_id=>@organization.id}
        assigns(:scrap).should be_a(Scrap)
        assigns(:scrap).should be_persisted
      end

      it "redirects to the created scrap" do
        post :create, {:scrap => valid_attributes, :organization_id=>@organization.id}
        response.should redirect_to([@organization, Scrap.last])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved scrap as @scrap" do
        # Trigger the behavior that occurs when invalid params are submitted
        Scrap.any_instance.stub(:save).and_return(false)
        post :create, {:scrap => {}, :organization_id=>@organization.id}
        assigns(:scrap).should be_a_new(Scrap)
      end

    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested scrap" do
        scrap = Scrap.create! valid_attributes
      scrap.user = @user
      scrap.organization = @organization
      scrap.save
        # Assuming there are no other scraps in the database, this
        # specifies that the Scrap created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Scrap.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => scrap.to_param, :scrap => {'these' => 'params'}, :organization_id=>@organization.id}
      end

      it "assigns the requested scrap as @scrap" do
        scrap = Scrap.create! valid_attributes
      scrap.user = @user
      scrap.organization = @organization
      scrap.save
        put :update, {:id => scrap.to_param, :scrap => valid_attributes.merge!({:title=>scrap.title}), :organization_id=>@organization.id}
        assigns(:scrap).should eq(scrap)
      end

      it "redirects to the scrap" do
        scrap = Scrap.create! valid_attributes
      scrap.user = @user
      scrap.organization = @organization
      scrap.save
        put :update, {:id => scrap.to_param, :scrap => valid_attributes.merge!({:title=>scrap.title}), :organization_id=>@organization.id}
        response.should redirect_to([@organization, scrap])
      end
    end

    describe "with invalid params" do
      it "assigns the scrap as @scrap" do
        scrap = Scrap.create! valid_attributes
      scrap.user = @user
      scrap.organization = @organization
      scrap.save
        # Trigger the behavior that occurs when invalid params are submitted
        Scrap.any_instance.stub(:save).and_return(false)
        put :update, {:id => scrap.to_param, :scrap => {:title=>""}, :organization_id=>@organization.id}
        assigns(:scrap).should eq(scrap)
      end

    end
  end

  describe "DELETE destroy" do
    it "destroys the requested scrap" do
      scrap = Scrap.create! valid_attributes
      scrap.user = @user
      scrap.organization = @organization
      scrap.save
      expect {
        delete :destroy, {:id => scrap.to_param, :organization_id=>@organization.id}
      }.to change(Scrap, :count).by(-1)
    end

    it "redirects to the scraps list" do
      scrap = Scrap.create! valid_attributes
      scrap.user = @user
      scrap.organization = @organization
      scrap.save
      delete :destroy, {:id => scrap.to_param, :organization_id=>@organization.id}
      response.should redirect_to([@organization, :scraps])
    end
  end

end