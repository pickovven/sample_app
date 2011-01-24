module SessionsHelper

  def sign_in(user)
	cookies.permanent.signed[:remember_token] = [user.id, user.salt]
	self.current_user = user
  end

  def current_user=(user)
	@current_user = user
  end

  def current_user
	@current_user ||= user_from_remember_token
  end
  
  def signed_in?
	!current_user.nil?
  end

  def sign_out
	cookies.delete(:remember_token)
	self.current_user = nil
  end

  def current_user?(user)
	user == current_user
  end

  def deny_access
	store_location
	redirect_to signin_path, :notice => "Please sign in to access this page."
  end
	
  def redirect_back_or(default)
	redirect_to(session[:return_to] || default)
	clear_return_to
  end

  def authenticate
	deny_access unless signed_in?
  end

  def deny_access
	store_location
	redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def character_count(field_id, update_id, options = {})
	function = "$('#{update_id}').innerHTML = (140 - ($F('#{field_id}').length));"
	out = javascript_tag(function) # set current length
	out += observe_field(field_id, options.merge(:function => function)) # and observe it
	return out
  end
  
  def alternate_colors
    color = "$('ul > li').filter(':nth-child(odd)').css('background', '#FDD')
    .end().filter(':nth-child(even)').css('background', '#FFD');"
    out = color
  end
  
  private

	def user_from_remember_token
	  User.authenticate_with_salt(*remember_token)
	end

	def remember_token
	  cookies.signed[:remember_token] || [nil, nil]
	end

	def store_location
	  session[:return_to] = request.fullpath
	end

	def clear_return_to
	  session[:return_to] = nil
	end
end

