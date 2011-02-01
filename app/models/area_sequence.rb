class AreaSequence < ActiveRecord::Base
  # == Constants ============================================================

  # == Extensions ===========================================================

  # == Relationships ========================================================
  
  belongs_to :area
  
  # == Validations ==========================================================

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================
  
  def self.increment(area_id)
    self.connection.select_value(
      self.sanitize_sql([
        "UPDATE #{table_name} 
        SET sequence_number=sequence_number+1 
        WHERE area_id=?
        RETURNING sequence_number",
        area_id
      ])
    ).to_i
  end

  def self.counter_for(area_id)
    self.connection.select_value(
      self.sanitize_sql([
        "SELECT sequence_number FROM #{table_name} WHERE area_id=?",
        area_id
      ])
    ).to_i
  end
  
  # == Instance Methods =====================================================
end
