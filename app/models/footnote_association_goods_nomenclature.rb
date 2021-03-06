class FootnoteAssociationGoodsNomenclature < Sequel::Model
  plugin :time_machine
  plugin :oplog, primary_key: [:footnote_id,
                               :footnote_type,
                               :goods_nomenclature_sid]
  plugin :conformance_validator

  set_primary_key [:footnote_id, :footnote_type, :goods_nomenclature_sid]
end


