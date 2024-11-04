module ContactHelper
  def contact
    return @contact unless @contact.nil?

    name = 'sobject_model:test contact'
    if record_exist?(:Contact, Name: name)
      sf.data.delete_record :Contact, where: {Name: name}, target_org: target_org
    end
    @contact = create :Contact, LastName: name, BirthDate: Date.new(1975,5,16)
  end

  def contact_id
    Object.const_get(:Contact)
    contact.Id
  rescue NameError => e
    contact['Id']
  end

  def contact_name
    Object.const_get(:Contact)
    contact.Name
  rescue NameError => e
    contact['Name']
  end

  def reload_contact
    return if @contact.nil?

    Object.const_get(:Contact)
    @contact = sf.data.get_record :Contact, record_id: contact_id, target_org: target_org, model_class: Contact
  rescue NameError => e
    @contact = sf.data.get_record :Contact, record_id: contact_id, target_org: target_org
  end
end

World(ContactHelper)
