class MeursingTableCellComponent < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number
  
  belongs_to :meursing_additional_code, foreign_key: :meursing_additional_code_sid
  belongs_to :meursing_table_plan
end