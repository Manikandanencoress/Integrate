class AddCorrelationIdToPaypal < ActiveRecord::Migration
  def self.up
    add_column :paypals, :correlationid, :string, :limit => 40
  end

  def self.down
    remove_column :paypals, :correlationid
  end
end
