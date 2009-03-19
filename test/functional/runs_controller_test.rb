require File.dirname(__FILE__) + '/../test_helper'
require 'runs_controller'

# Re-raise errors caught by the controller.
class RunsController; def rescue_action(e) raise e end; end

class RunsControllerTest < Test::Unit::TestCase
  fixtures :runs

  def setup
    @controller = RunsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def login
    get :list
    post :signin, :username=>'bohms', :password=>'lter'
  end

  def test_index
    login
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    login
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:runs)
  end

  def test_show
    login
    
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:run)
    assert assigns(:run).valid?
  end

  def test_new
    login
    
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:run)
  end
  
  def test_redirect_to_login_page
    get :list
    assert_response :redirect
    assert_redirected_to :action => "signin"
  end
  
  def test_signin
    login
    assert_response :redirect
    assert_redirected_to :action => "list"   
  end

  def test_create
    login
    file = File.open(File.dirname(__FILE__) + '/../data/lter2004-series9.csv')
    lines = file.read()
    sio = StringIO.new(lines)
    post :create, :run => { }, :file_name => sio
    assert_response :redirect
    assert_redirected_to :controller=>'runs', :action => 'list'
  end
  
  def test_extra_whitespace_in_id
    login
    file = File.open(File.dirname(__FILE__) + '/../data/lter2004-series9.csv')
    lines = file.read()
    sio = StringIO.new(lines)
    post :create, :run => { }, :file_name => sio
    assert_response :redirect
    assert_redirected_to :controller=>'runs', :action => 'list'
    file = File.open(File.dirname(__FILE__) + '/../data/lter2006-series5.csv')
    lines = file.read()
    sio =  StringIO.new(lines)
    post :data, :id => 1,  :file_name => sio
    assert_response :redirect
    assert_redirected_to :action => "list"
  end

  def test_edit
    login
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:run)
    assert assigns(:run).valid?
  end

  def test_update
   # login
    #post :update, :id => 1
    #assert_response :redirect
    #assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    login
    assert_not_nil Run.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Run.find(1)
    }
  end
end
