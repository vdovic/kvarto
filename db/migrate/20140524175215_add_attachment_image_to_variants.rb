class AddAttachmentImageToVariants < ActiveRecord::Migration
  	def self.up
    	change_table :variants do |t|
    		t.attachment :image
  		end
	end

  def self.down
    drop_attached_file :variants, :image
  end
end