class UniquenessOnDomainValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.domain.local_parts_not_belonging_to(record).include? value
      record.errors[attribute] << (options[:message] || "is already in use on domain")
    end
  end
end