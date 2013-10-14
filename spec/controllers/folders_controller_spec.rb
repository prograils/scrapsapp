require 'spec_helper'

describe FoldersController do

  # This should return the minimal set of attributes required to create a valid
  # Folder. As you add validations to Folder, be sure to
  # update the return value of this method accordingly.
  def valid_attributes(user=nil)
    user ||= FactoryGirl.create(:user)
    FactoryGirl.attributes_for(:folder, organization: user.private_organization)
  end

  before(:each) do
    login_user
    @user = User.first
    @organization = FactoryGirl.create(:organization)
    @organization.make_user(@user)
  end

  describe "GET index" do
    it "assigns all folders as @folders" do
      folder = Folder.new valid_attributes(@user)
      folder.organization = @organization
      folder.save
      get :index, {organization_id: @organization.id}
      assigns(:folders).should eq([folder])
    end
  end

  describe "GET show" do
    it "assigns the requested folder as @folder" do
      folder = Folder.new valid_attributes(@user)
      folder.organization = @organization
      folder.save
      get :show, {organization_id: @organization.id, :id => folder.id}
      assigns(:folder).should eq(folder)
    end
  end

  describe "GET new" do
    it "assigns a new folder as @folder" do
      get :new, {organization_id: @organization.id}
      assigns(:folder).should be_a_new(Folder)
    end
  end

  describe "GET edit" do
    it "assigns the requested folder as @folder" do
      folder = Folder.new valid_attributes(@user)
      folder.organization = @organization
      folder.save
      get :edit, {organization_id: @organization.id, :id => folder.id}
      assigns(:folder).should eq(folder)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Folder" do
        expect {
          post :create, {organization_id: @organization.id, :folder => valid_attributes}
        }.to change(Folder, :count).by(1)
      end

      it "assigns a newly created folder as @folder" do
        post :create, {organization_id: @organization.id, :folder => valid_attributes}
        assigns(:folder).should be_a(Folder)
        assigns(:folder).should be_persisted
      end

      it "redirects to the created folder" do
        post :create, {organization_id: @organization.id, :folder => valid_attributes}
        response.should redirect_to(organization_folders_path(@organization))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved folder as @folder" do
        # Trigger the behavior that occurs when invalid params are submitted
        Folder.any_instance.stub(:save).and_return(false)
        post :create, {organization_id: @organization.id, :folder => {}}
        assigns(:folder).should be_a_new(Folder)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested folder" do
        folder = Folder.new valid_attributes(@user)
        folder.organization = @organization
        folder.save
        # Assuming there are no other folders in the database, this
        # specifies that the Folder created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Folder.any_instance.should_receive(:update_attributes).with({'name' => 'new name'})
        put :update, {organization_id: @organization.id, :id => folder.id, :folder => {'name' => 'new name'}}
      end

      it "assigns the requested folder as @folder" do
        folder = Folder.new valid_attributes(@user)
        folder.organization = @organization
        folder.save
        put :update, {organization_id: @organization.id, :id => folder.id, :folder => valid_attributes}
        assigns(:folder).should eq(folder)
      end

      it "redirects to the folder" do
        folder = Folder.new valid_attributes(@user)
        folder.organization = @organization
        folder.save
        put :update, {organization_id: @organization.id, :id => folder.id, :folder => valid_attributes}
        response.should redirect_to(organization_folders_path(@organization))
      end
    end

    describe "with invalid params" do
      it "assigns the folder as @folder" do
        folder = Folder.new valid_attributes(@user)
        folder.organization = @organization
        folder.save
        # Trigger the behavior that occurs when invalid params are submitted
        Folder.any_instance.stub(:save).and_return(false)
        put :update, {organization_id: @organization.id, :id => folder.id, :folder => {}}
        assigns(:folder).should eq(folder)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested folder" do
      folder = Folder.new valid_attributes(@user)
      folder.organization = @organization
      folder.save
      expect {
        delete :destroy, {organization_id: @organization.id, :id => folder.id}
      }.to change(Folder, :count).by(-1)
    end

    it "redirects to the folders list" do
      folder = Folder.new valid_attributes(@user)
      folder.organization = @organization
      folder.save
      delete :destroy, {organization_id: @organization.id, :id => folder.id}
      response.should redirect_to(organization_folders_url(@organization))
    end
  end

end
