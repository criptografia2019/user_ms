class WsusersController < ApplicationController
    soap_service namespace: 'urn:WashOutUser', camelize_wsdl: :lower

    # Check if user exist in data base by searching username
    # returns true/false, id user
    soap_action "checkUser",
                   :args => {:username => :string},
                   :return => {:userValid => :boolean, :userId => :integer}

    def checkUser
        if(User.exists?(username: params[:username]))
            user = User.where(username: params[:username]).first
            render :soap => {:userValid => true, :userId => user.id}
        else
            render :soap => {:userValid => false, :userId => -1}
        end
    end

    # Check if user exist in data base by searching email
    # returns true/false, username
    soap_action "checkUserEmail",
                    :args => {:userEmail => :string},
                    :return => {:userValid => :boolean, :username => :string }

    def checkUserEmail
        if(User.exists?(email: params[:userEmail]))
            user =  User.find(params[:userEmail])
            render :soap => {:userValid => true, :username => user.username}
        else
            render :soap => {:userValid => false, :username => "No existe usuario"}
        end
    end

    # Check if user exist in data base by searching id
    # returns true/false, username

    soap_action "checkUserId",
                    :args => {:userId => :integer},
                    :return => {:userValid => :boolean, :username => :string}
    def checkUserId
        if(User.exists?(id: params[:userId]))
            user = User.find(params[:userId])
            render :soap => { :userValid => true, :username => user.username }
        else
            render :soap => { :userValid => false, :username => "No existe usuario" }
        end
    end
end
