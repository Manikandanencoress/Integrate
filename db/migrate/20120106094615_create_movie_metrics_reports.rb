class CreateMovieMetricsReports < ActiveRecord::Migration
  def self.up
    create_table :movie_metrics_reports do |t|
      t.date :date
      t.integer :movie_id
      t.integer :daily_active_users
      t.integer :page_views
      t.integer :page_view_unique
      t.integer :page_like

      t.timestamps
    end
  end

  def self.down
    drop_table :movie_metrics_reports
  end
end
