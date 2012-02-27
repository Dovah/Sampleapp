require 'spec_helper'

describe UsersController do
  render_views
  
  describe "GET 'new'" do
    
      it "debe ser estar correcto" do
        get :new
        response.should be_success
      end
      
      it "debe tener un titulo correcto" do
        get :new
        response.should have_selector("title", :content => "Sign up")
      end
      
  end
  describe "GET 'show'" do
    
      before(:each) do
        @user = Factory(:user)
      end
    
      it "should be successful" do
          get :show, :id => @user
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
  
  describe "POST 'create'" do
    
    describe "fallo" do
      before(:each) do
        @attr = { :name=>"",
                  :email=>"",
                  :password=>"",
                  :password_confirmation=>""
                  }
      end
      
      it "debe no crear el usuario" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
        
      end
      
      it "debe tener el titulo correcto" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end
      
      it "debe cargar la pagina 'new'" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    
    describe "succes" do
      
      before(:each) do
        @attr ={ :name => "New User",
                 :email => "User@example.com",
                 :password => "foobar",
                 :password_confirmation => "foobar"}
      end
      
      it "debe registrar la entrada de usuario" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
      
      it "debe crear el usuario" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
       end
       
       it "debe redireccionar a la pagina show" do
         post :create, :user => @attr
         response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "debe tener un mensaje de bienvenida" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end
      
      
    end
  end
end