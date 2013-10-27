require 'spec_helper'

describe ScrapsController do

  # This should return the minimal set of attributes required to create a valid
  # Scrap. As you add validations to Scrap, be sure to
  # update the return value of this method accordingly.
  def valid_attributes(user=nil)
    user ||= FactoryGirl.create(:user)
    s = FactoryGirl.attributes_for(:scrap, user: user)
    s.delete(:user_id)
    s.delete(:organization_id)
    s.delete(:id)
    s
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ScrapsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  before(:each) do
    login_user
    @user = User.first
    @organization = FactoryGirl.create(:organization)
    @organization.make_user(@user)
  end

  describe "GET index" do
    it "assigns all scraps as @scraps" do
      scrap = Scrap.new valid_attributes
      scrap.user = @user
      scrap.organization = @organization
      scrap.save
      get :index, {:organization_id=>@organization.id}
      assigns(:scraps).should eq([scrap])
    end
  end

  describe "GET show" do
    it "assigns the requested scrap as @scrap" do
      scrap = Scrap.new valid_attributes
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
      scrap = Scrap.new valid_attributes
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

      it "creates a new Scrap with files" do
        a = valid_attributes
        a[:single_files_attributes] = {
          id: nil,
          name: 'test.txt',
          content: 'readme content'
        }
        expect {
          post :create, {:scrap => a, :organization_id=>@organization.id}
        }.to change(SingleFile, :count).by(1)
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
        scrap = Scrap.new valid_attributes
        scrap.user = @user
        scrap.organization = @organization
        scrap.save
        #Scrap.any_instance.should_receive(:update_attributes).with({'title' => 'terefere'})
        put :update, {:id => scrap.to_param, :scrap => {'title' => 'terefere'}, :organization_id=>@organization.id}
        scrap.reload
        scrap.title.should eq('terefere')
      end

      it "assigns the requested scrap as @scrap" do
        scrap = Scrap.new valid_attributes
        scrap.user = @user
        scrap.organization = @organization
        scrap.save
        put :update, {:id => scrap.to_param, :scrap => valid_attributes.merge!({:title=>scrap.title}), :organization_id=>@organization.id}
        assigns(:scrap).should eq(scrap)
      end

      it "redirects to the scrap" do
        scrap = Scrap.new valid_attributes
        scrap.user = @user
        scrap.organization = @organization
        scrap.save
        put :update, {:id => scrap.to_param, :scrap => valid_attributes.merge!({:title=>scrap.title}), :organization_id=>@organization.id}
        response.should redirect_to([@organization, scrap])
      end
    end

    describe "with invalid params" do
      it "assigns the scrap as @scrap" do
        scrap = Scrap.new valid_attributes
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
      scrap = Scrap.new valid_attributes
      scrap.user = @user
      scrap.organization = @organization
      scrap.save
      expect {
        delete :destroy, {:id => scrap.to_param, :organization_id=>@organization.id}
      }.to change(Scrap, :count).by(-1)
    end

    it "redirects to the scraps list" do
      scrap = Scrap.new valid_attributes
      scrap.user = @user
      scrap.organization = @organization
      scrap.save
      delete :destroy, {:id => scrap.to_param, :organization_id=>@organization.id}
      response.should redirect_to([@organization, :scraps])
    end
  end

end
