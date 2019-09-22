class PgStatActivity < ApplicationRecord
  self.table_name = 'pg_stat_activity'
  self.primary_key = 'datid'

  def readonly?
    true
  end
end
