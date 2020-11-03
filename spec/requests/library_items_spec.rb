 require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/collection/:collection_id/library_items", type: :request do
  let(:library_item) {
    library_items(:book1)
  }

  # LibraryItem. As you add validations to LibraryItem, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { item_type: "Boek", title: "Nieuw item titel"}
  }

  let(:invalid_attributes) {
    { item_type: "Bloek", title: "Nieuw item titel"}
  }

  describe "GET /index" do
    it "redirects to sign in path when not signed in" do
      get collection_library_items_url(collections(:collection1))
      expect(response).to redirect_to new_user_session_path
    end

    it "redirects to root path when insufficient credentials" do
      sign_in(users(:read_only))
      get collection_library_items_url(collections(:collection1))
      expect(response).to redirect_to root_path
    end

    it "displays for compliance" do
      sign_in(users(:compliance))
      get collection_library_items_url(collections(:collection1))
      expect(response).to be_successful
    end

    it "displays for compliance at work level" do
      sign_in(users(:compliance))
      get collection_work_library_items_url(collections(:collection1), works(:work1))
      expect(response).to be_successful
      expect(response.body).to match("LibrayItemBoekTitel")
    end

    it "doesn't display for compliance at another collection" do
      sign_in(users(:compliance))
      get collection_library_items_url(collections(:collection3))
      expect(response).to redirect_to root_path
    end
  end

  describe "GET /show" do
    it "renders a successful response for compliance at work level" do
      sign_in(users(:compliance))
      get collection_work_library_item_url(collections(:collection1), works(:work1), library_items(:book1))
      expect(response).to be_successful
      expect(response.body).to match("<h2>Boek: LibrayItemBoekTitel</h2>")
    end
  end

  describe "GET /new" do
    it "renders a redirect response for compliance" do
      sign_in(users(:compliance))
      get new_collection_work_library_item_url(collections(:collection1), works(:work1))
      expect(response).to redirect_to root_path
      get new_collection_library_item_url(collections(:collection1), library_items(:book1))
      expect(response).to redirect_to root_path
    end

    it "renders for registrator" do
      sign_in(users(:registrator))
      get new_collection_work_library_item_url(collections(:collection1), works(:work1))
      expect(response).to be_successful
      expect(response.body).not_to match "<td>Boek: LibrayItemBoekTitel</td>" #should recouple

      get new_collection_library_item_url(collections(:collection1))
      expect(response).to be_successful
    end

    it "renders couple action when isn't yet coupled" do
      sign_in(users(:registrator))
      get new_collection_work_library_item_url(collections(:collection1), works(:work2))
      expect(response).to be_successful
      expect(response.body).to match "<td>Boek: LibrayItemBoekTitel</td>"
      expect(response.body).to match "Koppel"
    end

    it "renders a form" do
      sign_in(users(:registrator))
      get new_collection_work_library_item_url(collections(:collection1), works(:work2))
      expect(response.body).to match "id=\"library_item_item_type\""
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      sign_in(users(:registrator))
      get edit_collection_work_library_item_url(collections(:collection1), works(:work1), library_items(:book1))
      expect(response).to be_successful
      expect(response.body).to match("LibrayItemBoekTitel")
      expect(response.body).to match "id=\"library_item_item_type\""
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a no new LibraryItem when not signed in" do
        expect {
          post collection_library_items_url(collections(:collection1)), params: { library_item: valid_attributes }
        }.not_to change(LibraryItem, :count)
      end

      context "signed in as registrator" do
        before do
          sign_in(users(:registrator))
        end

        it "creates a new LibraryItem when signed in" do
          sign_in(users(:registrator))
          expect {
            post collection_library_items_url(collections(:collection1)), params: { library_item: valid_attributes }
          }.to change(LibraryItem, :count).by(1)
        end

        it "redirects to the created library_item" do
          sign_in(users(:registrator))

          post collection_library_items_url(collections(:collection1)), params: { library_item: valid_attributes }
          expect(response).to redirect_to(collection_library_item_url(collections(:collection1), LibraryItem.last))
        end
      end
    end

    context "with invalid parameters" do
      before do
        sign_in(users(:registrator))
      end
      it "does not create a new LibraryItem" do
        expect {
          post collection_library_items_url(collections(:collection1)), params: { library_item: invalid_attributes }
        }.to change(LibraryItem, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post collection_library_items_url(collections(:collection1)), params: { library_item: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    before do
      sign_in(users(:registrator))
    end

    context "with valid parameters" do
      let(:new_attributes) {
        {
          item_type: "DVD"
        }
      }

      it "updates the requested library_item" do
        expect(library_item.item_type).to eq("Boek")
        patch collection_library_item_url(collections(:collection1), library_items(:book1)), params: { library_item: new_attributes }
        library_item.reload
        expect(library_item.item_type).to eq("DVD")
      end

      it "redirects to the library_item" do
        patch collection_library_item_url(collections(:collection1), library_items(:book1)), params: { library_item: new_attributes }
        library_item.reload
        expect(response).to redirect_to(collection_library_item_url(collections(:collection1), library_item))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        patch collection_library_item_url(collections(:collection1), library_items(:book1)), params: { library_item: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "doesnt destroys the requested library_item when not signed in" do
      expect {
        delete collection_library_item_url(collections(:collection1), library_items(:book1))
      }.not_to change(LibraryItem, :count)
    end

    it "doesnt destroys the requested library_item when not signed in as registrator" do
      sign_in(users(:registrator))
      expect {
        delete collection_library_item_url(collections(:collection1), library_items(:book1))
      }.not_to change(LibraryItem, :count)
    end
    it "does destroys the requested library_item when signed in as admin" do
      sign_in(users(:admin))
      expect {
        delete collection_library_item_url(collections(:collection1), library_items(:book1))
      }.to change(LibraryItem, :count).by(-1)
    end

    it "redirects to the library_items list" do
      sign_in(users(:admin))

      delete collection_library_item_url(collections(:collection1), library_items(:book1))
      expect(response).to redirect_to(collection_library_items_url)
    end
  end
end
