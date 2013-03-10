RSpec::Matchers.define :require_sign_in do
  match do |actual|
    redirect_to Rails.application.routes.url_helpers.sign_in_path
  end
  
  failure_message_for_should do |actual|
    "expected to require sign-in to access the method"
  end
  
  failure_message_for_should_not do |actual|
    "expected not to require sign-in to access the method"
  end
  
  description do
    "redirect to the sign in form"
  end
end