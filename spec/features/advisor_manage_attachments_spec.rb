# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "Manage attachments", type: :feature do
  include FeatureHelper

  context "in context of collection, as advisor" do
    scenario "add attachment, change name" do
      login "qkunst-test-advisor@murb.nl"

      click_on "Collecties"
      if page.body.match?("id=\"list-to-filter\"")
        within "#list-to-filter" do
          click_on "Collection 1"
        end
      end
      click_on "Beheer bijlagen"
      click_on "Bijlage toevoegen"
      attach_file "Bestand", File.expand_path("../fixtures/image.jpg", __dir__)
      fill_in("Bestandsnaam / beschrijving", with: "Image1.jpg")
      check("Registrator")
      click_on "Bijlage toevoegen"
      expect(page).to have_content("Attachment toegevoegd")
      expect(page).to have_content("Image1.jpg")
      click_on "Beheer bijlagen"
      expect(page).to have_content("Image1.jpg")

      click_on "Bewerk"
      fill_in("Bestandsnaam / beschrijving", with: "Image1 beperkt.jpg")

      click_on "Bijlage bewaren"
      expect(page).to have_content("Attachment bijgewerkt")
      expect(page).to have_content("Image1 beperkt.jpg")
    end
  end
  context "in context of work, as advisor" do
    scenario "add existing attachment" do
      login "qkunst-test-advisor@murb.nl"

      collection = collections(:collection1)

      visit collection_path(collection)

      click_on "Beheer bijlagen"
      click_on "Bijlage toevoegen"

      attach_file "Bestand", File.expand_path("../fixtures/image.jpg", __dir__)
      fill_in("Bestandsnaam / beschrijving", with: "Image1.jpg")
      check("Registrator")
      click_on "Bijlage toevoegen"
      expect(page).to have_content("Attachment toegevoegd")

      visit collection_works_path(collection)

      click_on "Work2"
      click_on "Bijlage toevoegen"
      first("[value=Koppel]").click

      expect(page).to have_content("Attachment bijgewerkt")
      expect(page).to have_content("Image1.jpg")
    end
  end
  context "in context of artist, as advisor" do
    scenario "add new and couple existing attachment" do
      login "qkunst-test-advisor@murb.nl"

      collection = collections(:collection1)

      visit collection_artists_path(collection)

      click_on "artist_1"
      click_on "Bijlage toevoegen"

      attach_file "Bestand", File.expand_path("../fixtures/image.jpg", __dir__)
      fill_in("Bestandsnaam / beschrijving", with: "ArtistImage1.jpg")
      check("Registrator")
      click_on "Bijlage toevoegen"
      expect(page).to have_content("Attachment toegevoegd")
      expect(page).to have_content("ArtistImage1.jpg")

      visit collection_artists_path(collection)
      click_on "artist_2"
      click_on "Bijlage toevoegen"
      first("[value=Koppel]").click

      expect(page).to have_content("Attachment bijgewerkt")
      expect(page).to have_content("ArtistImage1.jpg")
    end
  end
end
