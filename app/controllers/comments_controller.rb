require 'oauth'
require 'oauth-plugin'
require 'oauth/controllers/provider_controller'
class CommentsController < ApplicationController
  include OAuth::Controllers::ProviderController

  before_filter :my_login_or_oauth_required

  def this_is_my_filter 
    logger.debug "running my filter"
    logger.debug "current user is #{current_user.inspect}"
    return true 
  end 

  def my_login_or_oauth_required

    begin 
      if ClientApplication.verify_request(request) do |request_proxy|
        @client_application = ClientApplication.find_by_key(request_proxy.consumer_key)

        # Store this temporarily in client_application object for use in request token generation 
        @client_application.token_callback_url=request_proxy.oauth_callback if request_proxy.oauth_callback

        # return the token secret and the consumer secret
        [nil, @client_application.secret]
      end
      logger.debug "access granted"
      true
      else
        logger.debug "access denied"
        false
      end
    rescue 
      logger.debug "access denied"
      false 
    end 

  end 

  # GET /comments
  # GET /comments.xml
  def index
    puts request.inspect
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
      format.json { render :json => @comments }
    end
  end

  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        format.html { redirect_to(@comment, :notice => 'Comment was successfully created.') }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to(@comment, :notice => 'Comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
    end
  end
end
