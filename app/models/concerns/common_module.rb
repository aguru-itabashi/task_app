module CommonModule
  extend ActiveSupport::Concern

  included do
    def created_time
			created_at.strftime("%Y年%-m月%-d日　%-H時%-M分")
		end

		def updated_time
			updated_at.strftime("%Y年%-m月%-d日　%-H時%-M分")
		end
  end
end