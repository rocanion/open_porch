class AreaSequence < ActiveRecord::Base
  # == Constants ============================================================

  # == Extensions ===========================================================

  # == Relationships ========================================================
  
  # == Validations ==========================================================

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================

  
  def self.increment(area_id)
    self.prepare_counter_for(area_id)

    self.connection.select_value(
      self.sanitize_sql([
        "UPDATE #{table_name} SET sequence_number=sequence_number+1 WHERE area_id=?
        RETURNING area_id",
        area_id
      ])
    ).to_i
    
    # self.connection.select_value("SELECT LAST_INSERT_ID()").to_i
  end

  def self.counter_for(area_id)
    self.prepare_counter_for(area_id)

    self.connection.select_value(
      self.sanitize_sql([
        "SELECT sequence_number FROM #{table_name} WHERE area_id=?",
        area_id
      ])
    ).to_i
  end
  
  def self.prepare_counter_for(area_id)
    self.connection.execute(
      self.sanitize_sql([
        "INSERT INTO #{table_name} (area_id, sequence_number) VALUES(?, 0)", area_id
      ])
    )
  rescue ActiveRecord::RecordNotUnique
    
  end
  

  # == Instance Methods =====================================================
end
