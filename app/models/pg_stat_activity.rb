class PgStatActivity < ApplicationRecord
  self.table_name = 'pg_stat_activity'
  self.primary_key = 'pid'

  def readonly?
    true
  end

  def cancel_backend!
    sql = "select pg_cancel_backend(#{pid});"
    ActiveRecord::Base.connection.execute(sql)
  end
end
