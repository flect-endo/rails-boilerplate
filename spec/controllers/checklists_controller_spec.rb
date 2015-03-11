require 'rails_helper'

RSpec.describe ChecklistsController, type: :controller do
  login_admin

  # This should return the minimal set of attributes required to create a valid
  # Checklist. As you add validations to Checklist, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { title: "Collect coins" }
  }

  let(:invalid_attributes) {
    { title: "" }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ChecklistsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all checklists as @checklists" do
      checklist = Checklist.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:checklists)).to eq([checklist])
    end
  end

  describe "GET #show" do
    it "assigns the requested checklist as @checklist" do
      checklist = Checklist.create! valid_attributes
      get :show, {:id => checklist.to_param}, valid_session
      expect(assigns(:checklist)).to eq(checklist)
    end
  end

  describe "GET #new" do
    it "assigns a new checklist as @checklist" do
      get :new, {}, valid_session
      expect(assigns(:checklist)).to be_a_new(Checklist)
    end
  end

  describe "GET #edit" do
    it "assigns the requested checklist as @checklist" do
      checklist = Checklist.create! valid_attributes
      get :edit, {:id => checklist.to_param}, valid_session
      expect(assigns(:checklist)).to eq(checklist)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Checklist" do
        expect {
          post :create, {:checklist => valid_attributes}, valid_session
        }.to change(Checklist, :count).by(1)
      end

      it "assigns a newly created checklist as @checklist" do
        post :create, {:checklist => valid_attributes}, valid_session
        expect(assigns(:checklist)).to be_a(Checklist)
        expect(assigns(:checklist)).to be_persisted
      end

      it "redirects to the created checklist" do
        post :create, {:checklist => valid_attributes}, valid_session
        expect(response).to redirect_to(Checklist.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved checklist as @checklist" do
        post :create, {:checklist => invalid_attributes}, valid_session
        expect(assigns(:checklist)).to be_a_new(Checklist)
      end

      it "re-renders the 'new' template" do
        post :create, {:checklist => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { title: "Eat mushrooms" }
      }

      it "updates the requested checklist" do
        checklist = Checklist.create! valid_attributes
        put :update, {:id => checklist.to_param, :checklist => new_attributes}, valid_session
        checklist.reload
        expect(checklist.title).to eq("Eat mushrooms")
      end

      it "assigns the requested checklist as @checklist" do
        checklist = Checklist.create! valid_attributes
        put :update, {:id => checklist.to_param, :checklist => valid_attributes}, valid_session
        expect(assigns(:checklist)).to eq(checklist)
      end

      it "redirects to the checklist" do
        checklist = Checklist.create! valid_attributes
        put :update, {:id => checklist.to_param, :checklist => valid_attributes}, valid_session
        expect(response).to redirect_to(checklist)
      end
    end

    context "with invalid params" do
      it "assigns the checklist as @checklist" do
        checklist = Checklist.create! valid_attributes
        put :update, {:id => checklist.to_param, :checklist => invalid_attributes}, valid_session
        expect(assigns(:checklist)).to eq(checklist)
      end

      it "re-renders the 'edit' template" do
        checklist = Checklist.create! valid_attributes
        put :update, {:id => checklist.to_param, :checklist => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested checklist" do
      checklist = Checklist.create! valid_attributes
      expect {
        delete :destroy, {:id => checklist.to_param}, valid_session
      }.to change(Checklist, :count).by(-1)
    end

    it "redirects to the checklists list" do
      checklist = Checklist.create! valid_attributes
      delete :destroy, {:id => checklist.to_param}, valid_session
      expect(response).to redirect_to(checklists_url)
    end
  end

end
