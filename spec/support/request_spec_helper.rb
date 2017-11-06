module RequestSpecHelper
  include Warden::Test::Helpers

  def json
    JSON.parse(response.body, symbolize_names: true)
  end

  def json_headers
    {
      'ACCEPT' => 'application/json',     # This is what Rails 4 accepts
      'HTTP_ACCEPT' => 'application/json', # This is what Rails 3 accepts
      'CONTENT_TYPE' => 'application/json'
    }
  end

  def self.included(base)
    base.before(:each) { Warden.test_mode! }
    base.after(:each) { Warden.test_reset! }
  end

  def sign_in(resource)
    login_as(resource, scope: warden_scope(resource))
  end

  def sign_out(resource)
    logout(warden_scope(resource))
  end

  private

  def warden_scope(resource)
    resource.class.name.underscore.to_sym
  end
end