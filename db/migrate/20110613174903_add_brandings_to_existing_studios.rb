class AddBrandingsToExistingStudios < ActiveRecord::Migration
  class Studio < ActiveRecord::Base
    has_one :branding
  end

  class Branding < ActiveRecord::Base
    belongs_to :studio
  end

  def self.up
    Studio.all.map { |s| s.branding= Branding.create! }
  end

  def self.down
  end
end
