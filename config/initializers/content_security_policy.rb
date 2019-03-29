Rails.application.config.content_security_policy do |policy|
  if Rails.env.development?
    policy.script_src :self, :https, :unsafe_eval
  else
    policy.script_src :self, :https
  end

  policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035" if Rails.env.development?
end
