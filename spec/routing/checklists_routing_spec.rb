require "rails_helper"

RSpec.describe ChecklistsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/checklists").to route_to("checklists#index")
    end

    it "routes to #new" do
      expect(:get => "/checklists/new").to route_to("checklists#new")
    end

    it "routes to #show" do
      expect(:get => "/checklists/1").to route_to("checklists#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/checklists/1/edit").to route_to("checklists#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/checklists").to route_to("checklists#create")
    end

    it "routes to #update" do
      expect(:put => "/checklists/1").to route_to("checklists#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/checklists/1").to route_to("checklists#destroy", :id => "1")
    end

  end
end
