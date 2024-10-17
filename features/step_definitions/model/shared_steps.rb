require 'yamori/generator'

Given('{string} class is already generated') do |klass|
  Yamori.connect(:rest, instance_url: host, access_token: token, api_version: api_ver)
  Yamori.generate(klass.to_sym)
  expect{ Object.const_get klass.to_sym }.not_to raise_error
end
