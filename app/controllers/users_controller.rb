class UsersController < ApplicationController

    before_action :set_user, only: [:edit, :update, :show]

    def new
        @user = User.new
    end

    def edit
    end

    def index
        @users = User.paginate(page: params[:page], per_page: 5)
    end

    def show
        @articles = @user.articles.paginate(page: params[:page], per_page: 5)
    end
  

    def update
        if @user.update(user_params)
            flash[:notice] = "Your account information was updated successfully."
            redirect_to @user
        else
            render 'edit'
        end
        
    end

    def create
        @user = User.new(user_params)
        if @user.save
            flash[:notice] = "Welcome to the Alpha Blog, #{@user.username}. You have successfully signed up."
            redirect_to @user
        else
            render 'new'
        end
    end
    
   

    private

    def set_user
        @user = User.find(params[:id])
    end
    

    def user_params
        params.require(:user).permit(:username, :email, :password)
    end
    
  end
  