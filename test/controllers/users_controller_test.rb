require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    sign_in users(:user1)  
  end
  
  test "#show should match case-insensitively" do
    get '/user/SpongeBoB'
    assert_response :success
  end
    
  test "#search should match first name, last name, or username" do
    get search_path(q: "cool")
    assert_equal assigns(:users).count, 3
  end
  
  test "#search should match partially" do
    get search_path(q: "ool")
    assert_equal assigns(:users).count, 3
  end
  
  test "#search should match from the joined first name and last name in any order" do
    get search_path(q: "bob squ")
    assert_equal assigns(:users).count, 1
    get search_path(q: "pants spo")
    assert_equal assigns(:users).count, 1
  end
  
  test "#search should match exact email" do
    get search_path(q: "cool@email.co")
    assert_equal assigns(:users).count, 0
    get search_path(q: "cool@email.com")
    assert_equal assigns(:users).count, 1
  end
  
  test "#search should return nothing when the query string is blank" do
    get search_path(q: " ")
    assert_equal assigns(:users).count, 0
    get search_path(q: nil)
    assert_equal assigns(:users).count, 0
  end
end
