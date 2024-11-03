Given('rest') do
  @connection_type = :rest
end

Given('CLI\/sf') do
  @connection_type = :"cli/sf"
end

Given('{string} class is already generated') do |klass|
  case @connection_type
  when :rest
    Yamori.connect(:rest, instance_url: host, access_token: token, api_version: api_ver)
  when :"cli/sf"
    Yamori.connect(:"cli/sf", target_org: org_alias)
  else
    Yamori.connect(:rest, instance_url: host, access_token: token, api_version: api_ver)
  end

  Yamori.generate(klass.to_sym)
  expect{ Object.const_get klass.to_sym }.not_to raise_error
end
