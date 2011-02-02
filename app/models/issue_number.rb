class IssueNumber < ActiveRecord::Base

  # == Relationships ========================================================
  
  belongs_to :area
  
  # == Instance Methods =====================================================
  
  def next
    self.sequence_number = self.connection.select_value("
      UPDATE #{self.class.table_name} 
      SET sequence_number=sequence_number+1 
      WHERE area_id= #{self.area_id}
      RETURNING sequence_number"
    ).to_i
  end

  def current
    self.sequence_number
  end
  
end
