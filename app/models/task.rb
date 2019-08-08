class Task < ApplicationRecord
	include CommonModule
	validates :name, presence: true
	validates :name, length: {maximum:30}
	validate :validate_name_not_including_comma
	# before_validation :set_nameless_name

	belongs_to :user

	scope :recent, -> {order(created_at: :desc)}

	def ransackable_attributes(auth_object = nil)
		%w[name created_at]
  end

  def ransackable_associations(auth_object = nil)
    []
  end

	private

	def validate_name_not_including_comma
		errors.add(:name, "にカンマを含めることはできません") if name&.include?(",")
	end

	# def set_nameless_name
	# 	self.name = "名前無し" if name.blank?
	# end
end
