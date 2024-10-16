class DataCleaner
  attr_reader :target_org, :target_records

  def initialize
    @target_records = []
    @target_org = ENV['SF_TARGET_ORG']
  end

  def add(object_type, id)
    @target_records << {object_type: object_type.to_sym, id: id}
    # puts "add #{id} of #{object_type} in DataCleaner"
  end

  def cleanup
    target_records.each do |target|
      begin
        rows = sf.data.query "SELECT Id FROM #{target[:object_type]} WHERE Id = '#{target[:id]}'", target_org: target_org
        if rows.count == 1
          sf.data.delete_record target[:object_type], record_id: target[:id], target_org: target_org
          # puts "delete #{target[:id]} of #{target[:object_type]} in DataCleaner"
        end
      rescue => e
        puts e.message
      end
    end
  end
end

module DataCleanerMethod
  def data_cleaner
    @data_cleaner ||= DataCleaner.new
  end
end

World(DataCleanerMethod)
