class BooksController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :index, :show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]

  def show
  	@book = Book.find(params[:id])
    @newbook = Book.new
    @book_comment = BookComment.new
    # @comments = BookComments.where(params[:id])
    @favorite = Favorite.new
  end

  def index
  	@books = Book.all #一覧表示するためにBookモデルの情報を全てくださいのall
    @book = Book.new
    @favorite = Favorite.new
  end

  def create
  	@book = Book.new(book_params) #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
  	@book.user_id = current_user.id
    if @book.save #入力されたデータをdbに保存する。
  		redirect_to book_path(@book.id), notice: "successfully created book!"#保存された場合の移動先を指定。
  	else
  		@books = Book.all
  		render 'index'
  	end
  end

  def edit
  	@book = Book.find(params[:id])
  end

  def update
  	@book = Book.find(params[:id])
  	if @book.update(book_params)
  		redirect_to book_path(@book.id), notice: "successfully updated book!"
  	else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
  		render "edit"
  	end
  end

  def destroy
  	@book = Book.find(params[:id])
  	@book.destroy
  	redirect_to books_path, notice: "successfully delete book!"
  end

  def correct_user
    @book = Book.find(params[:id])
      if @book.user.id !=  current_user.id
    redirect_to books_path
    end
    end

  def followings
      @user  = User.find(params[:id])
      @users = @user.followings
      redirect_to followings_user_path(@user)
  end

  def followers
    @user  = User.find(params[:id])
    @users = @user.followers
    redirect_to followers_user_path(@user)
  end

  private

  def book_params
  	params.require(:book).permit(:title, :body)
  end

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

  def correct_user
    @book = Book.find(params[:id])
      if @book.user.id !=  current_user.id
    redirect_to books_path
    end
    end

end
