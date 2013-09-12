class Change
  attr_accessor :model, :oid, :operation_date, :operation

  def initialize(attributes = {})
    attributes.each do |attribute, value|
      public_send("#{attribute}=", value) if respond_to?("#{attribute}=")
    end
  end

  def model=(model)
    @model = model.constantize
  end

  def operation_record
    @operation_record ||= operation_class.find(oid: oid)
  end

  def record
    operation_record.record
  end

  def model_name
    @model.name
  end

  def to_partial_path
    "changes/#{model_name.underscore}"
  end

  private

  def operation_class
    "#{model}::Operation".constantize
  end
end
