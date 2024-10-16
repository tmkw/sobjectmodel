module DataFactory
  def create(object_type, values ={})
    id = sf.data.create_record object_type.to_sym, values: values, target_org: target_org
    data_cleaner.add(object_type, id)
    sf.data.get_record object_type.to_sym, record_id: id, target_org: target_org, model_class: Object.const_get(object_type.to_sym)
  end
end

World(DataFactory)
