require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  login_admin

  let(:user) { create(:user) }

  let(:valid_attributes) {
    { user: user, title: "hoge" }
  }

  let(:invalid_attributes) {
    { user: user, title: "" }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # NotesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all notes as @notes" do
      note = Note.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:notes)).to eq([note])
    end
  end

  describe "GET #show" do
    it "assigns the requested note as @note" do
      note = Note.create! valid_attributes
      get :show, {:id => note.to_param}, valid_session
      expect(assigns(:note)).to eq(note)
    end
  end

  describe "GET #new" do
    it "assigns a new note as @note" do
      get :new, {}, valid_session
      expect(assigns(:note)).to be_a_new(Note)
    end
  end

  describe "GET #edit" do
    it "assigns the requested note as @note" do
      note = Note.create! valid_attributes
      get :edit, {:id => note.to_param}, valid_session
      expect(assigns(:note)).to eq(note)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Note" do
        expect {
          post :create, {:note => valid_attributes}, valid_session
        }.to change(Note, :count).by(1)
      end

      it "assigns a newly created note as @note" do
        post :create, {:note => valid_attributes}, valid_session
        expect(assigns(:note)).to be_a(Note)
        expect(assigns(:note)).to be_persisted
      end

      it "redirects to the created note" do
        post :create, {:note => valid_attributes}, valid_session
        expect(response).to redirect_to(Note.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved note as @note" do
        post :create, {:note => invalid_attributes}, valid_session
        expect(assigns(:note)).to be_a_new(Note)
      end

      it "re-renders the 'new' template" do
        post :create, {:note => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { title: "Eat mushrooms" }
      }

      it "updates the requested note" do
        note = Note.create! valid_attributes
        put :update, {:id => note.to_param, :note => new_attributes}, valid_session
        note.reload
        expect(note.title).to eq("Eat mushrooms")
      end

      it "assigns the requested note as @note" do
        note = Note.create! valid_attributes
        put :update, {:id => note.to_param, :note => valid_attributes}, valid_session
        expect(assigns(:note)).to eq(note)
      end

      it "redirects to the note" do
        note = Note.create! valid_attributes
        put :update, {:id => note.to_param, :note => valid_attributes}, valid_session
        expect(response).to redirect_to(note)
      end
    end

    context "with invalid params" do
      it "assigns the note as @note" do
        note = Note.create! valid_attributes
        put :update, {:id => note.to_param, :note => invalid_attributes}, valid_session
        expect(assigns(:note)).to eq(note)
      end

      it "re-renders the 'edit' template" do
        note = Note.create! valid_attributes
        put :update, {:id => note.to_param, :note => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested note" do
      note = Note.create! valid_attributes
      expect {
        delete :destroy, {:id => note.to_param}, valid_session
      }.to change(Note, :count).by(-1)
    end

    it "redirects to the notes list" do
      note = Note.create! valid_attributes
      delete :destroy, {:id => note.to_param}, valid_session
      expect(response).to redirect_to(notes_url)
    end
  end
end
