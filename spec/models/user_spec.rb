# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe User do
  
      before(:each) do
          @attr = { :name => "example user",
                    :email => "user@example.com",
                    :password => "foobar",
                    :password_confirmation => "foobar"
                    }
      end
  
      it "debe crear una nueva instancia con atributos validos" do
        User.create!(@attr)
      end
      
      it "requiere un nombre" do
        no_name_user = User.new(@attr.merge(:name => ""))
        no_name_user.should_not be_valid
      end
      
      it "debe tener un email" do
        no_email_user = User.new(@attr.merge(:email => ""))
        no_email_user.should_not be_valid
      end
      
      it "debe rechazar nombres muy largos" do
        long_name = "a" * 51
        long_name_user = User.new(@attr.merge(:name => long_name))
        long_name_user.should_not be_valid
      end
      
      it "debe aceptar un correo valido" do
        addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
        addresses.each do |address|
          valid_email_user = User.new(@attr.merge(:email => address))
          valid_email_user.should be_valid
        end
      end
      
      it "debe rechazar correo invalidos" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
        addresses.each do |address|
          invalid_email_user = User.new(@attr.merge(:email => address))
          invalid_email_user.should_not be_valid
        end
      end
      
      it "debe rechazar email duplicado" do
        User.create!(@attr)
        user_with_duplicate_email = User.new(@attr)
        user_with_duplicate_email.should_not be_valid
      end
      
      it "debe rechazar email identicos caso mayusculas" do
        upcased_email = @attr[:email].upcase
        User.create!(@attr.merge(:email => upcased_email))
        user_with_duplicate_email = User.new(@attr)
        user_with_duplicate_email.should_not be_valid
      end
      
      describe "validacion password" do
        
                before(:each) do
                  @user = User.create!(@attr)
                end
        
                it "debe pedir password" do
                    User.new(@attr.merge(:password => "", :password_confirmation => "")).
                    should_not be_valid
                end
        
                it "debe rechazar password cortas" do
                    short = "a" * 5
                    hash = @attr.merge(:password => short, :password_confirmation => short)
                    User.new(hash).should_not be_valid
                end
        
                it "debe rechazar password largas" do
                    long = "a" * 41
                    hash = @attr.merge(:password => long, :password_confirmation => long)
                    User.new(hash).should_not be_valid
                end
                
      end
      
      describe "encriptacion password" do
        
        before(:each) do
          @user = User.create!(@attr)
        end
        
                it "debe tener un atributo de password encriptada" do
                  @user.should respond_to(:encrypted_password)
                end
                
                it "debe establecer una password encriptada" do
                  @user.encrypted_password.should_not be_blank
                end
                
                describe "metodo has_password" do
                  
                          it "debe ser verdadero si password es correcta" do
                            @user.has_password?(@attr[:password]).should be_true
                          end
                          
                          it "debe ser falso si la password es incorrecta" do
                            @user.has_password?("invalid").should be_false
                          end
                 end
                 
                 describe "metodo Autentificacion" do
                          it "debe devolver nulo en email/password incorrectos" do
                            wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
                            wrong_password_user.should be_nil
                          end
                   
                          it "debe devolver nulo para un correo sin usuario " do
                            nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
                            nonexistent_user.should be_nil
                          end
                          
                          it "debe devolver el usuario con un correo/password correctos" do
                            matching_user = User.authenticate(@attr[:email], @attr[:password])
                            matching_user.should == @user
                          end                   
                 end
      end
end