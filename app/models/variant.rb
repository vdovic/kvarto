class Variant < ActiveRecord::Base
	belongs_to :user
	has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "http://www.aflglobal.com/productionFiles/images/noImageAvailable.aspx?width=100"

end
