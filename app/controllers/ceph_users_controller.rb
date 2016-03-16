class CephUsersController < ApplicationController

  skip_before_filter :redirect_to_cephlogin_if_required, only: [:create]

  def create
    if params[:email] && params[:email].length > 254 + 1 + 253
      return fail_with("login.email_too_long")
    end

    if SiteSetting.reserved_emails.split("|").include? params[:email].downcase
      return fail_with("login.reserved_email")
    end

    user = CephUser.new

    user_params.each { |k, v| user.send("#{k}=", v) }

    activation = UserActivator.new(user, request, session, cookies)
    activation.start

    if user.save
      activation.finish

      session["signup.created_cephaccount"] = activation.message
      redirect_with_success(buckets_path, "signup.created_cephaccount")
    else
      session["signup.create_cephfailure"] = activation.message
      redirect_with_failure(cockpits_path, "login.error", user.errors.full_messages.join("\n"))
    end
    #TO-DO rescure connection errors that come out.
    #rescue RestClient::Forbidden
    #redirect_with_failure(cockpits_path, ""nilavu.access_token_problem")
  end

  def fail_with(key)
    redirect_with_failure(cockpits_path, key)
  end

  def user_params
    params.permit(:email, :first_name, :last_name)
  end
end
