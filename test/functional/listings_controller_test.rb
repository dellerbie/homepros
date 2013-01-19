require 'test_helper'

class ListingsControllerTest < ActionController::TestCase
  setup do
    @listing = listings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:listings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create listing" do
    assert_difference('Listing.count') do
      post :create, listing: { budget_max: @listing.budget_max, budget_min: @listing.budget_min, city: @listing.city, company_logo: @listing.company_logo, company_name: @listing.company_name, contact_email: @listing.contact_email, phone: @listing.phone, portfolio_photo: @listing.portfolio_photo, portfolio_photo_description: @listing.portfolio_photo_description, state: @listing.state, website: @listing.website }
    end

    assert_redirected_to listing_path(assigns(:listing))
  end

  test "should show listing" do
    get :show, id: @listing
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @listing
    assert_response :success
  end

  test "should update listing" do
    put :update, id: @listing, listing: { budget_max: @listing.budget_max, budget_min: @listing.budget_min, city: @listing.city, company_logo: @listing.company_logo, company_name: @listing.company_name, contact_email: @listing.contact_email, phone: @listing.phone, portfolio_photo: @listing.portfolio_photo, portfolio_photo_description: @listing.portfolio_photo_description, state: @listing.state, website: @listing.website }
    assert_redirected_to listing_path(assigns(:listing))
  end

  test "should destroy listing" do
    assert_difference('Listing.count', -1) do
      delete :destroy, id: @listing
    end

    assert_redirected_to listings_path
  end
end
