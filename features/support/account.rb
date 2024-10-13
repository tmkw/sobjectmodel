module AccountHelper
  def account
    return @account unless @account.nil?

    name = 'yamori:test account'
    if record_exist?(:Account, Name: name)
      sf.data.delete_record :Account, where: {Name: name}, target_org: target_org
    end
    @account = create :Account, Name: name, BillingCity: 'Tokyo'
  end

  def account_id
    account.Id
  end

  def account_name
    account.Name
  end
end

World(AccountHelper)
