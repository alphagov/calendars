GovukError.configure do |config|
  config.excluded_exceptions << "GdsApi::TimedOutException"
  config.excluded_exceptions << "GdsApi::HTTPBadGateway"
  config.excluded_exceptions << "GdsApi::HTTPGatewayTimeout"
end
