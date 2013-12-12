RSpec::Matchers.define :allow_access do |*args|
  match do |permission|
    permission.allow?(*args).should be_true
  end
end
