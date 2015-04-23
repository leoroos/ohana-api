class RemoveLogFromImportJob < ActiveRecord::Migration
  def change
    remove_column :import_jobs, :log, :text
  end
end
