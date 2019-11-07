class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    if verifyInput(user_params)
      @user = User.new(email: user_params["email"], password: user_params["password"], password_confirmation: user_params["password_confirmation"])

      respond_to do |format|
        if @user.save
          session[:user_id] = @user.id
          format.html { redirect_to root_url, notice: "Logged in!" }
        else
          format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
          flash[:notice] = "Error creating account."
          print("Error Creating User")
          format.html { redirect_to action: "new"}
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to action: "new"}
      end
    end
  end

  def verifyInput params
    if not (params["email"].include? "@tamu.edu" or params["email"].include? "@blinn.edu")
      flash[:notice] = "Please use a Tamu or Blinn email."
      return false
    end
    if params["password"] != params["vPassword"]
      flash[:notice] = "Passwords do not match."
      return false
    end
    return true
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def admin_portal
    respond_to do |format|
    if @user.is_admin
      #if the user is an admin, let them see the page
      format.html { redirect_to 'sessions/show_admin', notice: 'Admin priviledges in use. '}
      format.json { render :show, status: :ok, location: @user }
    else
      #if the user is not an admin, politely inform them they are a technological pleb
      format.html { redirect_to root_url, notice: 'You have not been granted admin priviledges.' }
      format.json { head :no_content }
    end
  end
    
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :vPassword, :password_confirmation)
    end
  end
end
