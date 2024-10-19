module Misc
  def record_exist?(object_type, condition)
    sf.data.get_record object_type.to_sym, where: condition, target_org: target_org
    true
  rescue
    false
  end
end

World(Misc)

