require 'spec_helper'

describe UserController do
  render_views

  describe "GET 'show'" do
    
      before(:each) do
        @user = Factory(:user)
      end
    
      it "should be successful" do
          get :show, :id =>@user
          response.should be_success
      end
      
      it "debe buscar el usuario correcto" do
        get :show, :id => @user
        assings(:user).should == @user
      end
      
      it "debe tener el titulo correcto" do
          get :show, :id => @user
          response.should have_selector("title", :content => @user.name)
      end
      
      it "debe tener el nombre de usuario" do
        get :show, :id => @user
        response.should have_selector("h1", :content => @user.name)
      end
      
      it "debe tener un avatar" do
        get :show, :id => @user
        response.should have_selector("h1>img", :class => "gravatar")
      end
    
  end
  
end