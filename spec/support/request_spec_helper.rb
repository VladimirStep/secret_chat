module RequestSpecHelper
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
end