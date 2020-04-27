class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.string :image_id
      t.string :file_type
      t.references :attachmentable, polymorphic: true
      t.timestamps
    end
  end
end
