class Task < ApplicationRecord
	include CommonModule
	validates :name, presence: true
	validates :name, length: {maximum:30}
	validate :validate_name_not_including_comma
	# before_validation :set_nameless_name

	belongs_to :user

	has_one_attached :image

	scope :recent, -> {order(created_at: :desc)}

	def ransackable_attributes(auth_object = nil)
		%w[name created_at]
  end

  def ransackable_associations(auth_object = nil)
    []
  end

  def self.csv_attributes
    ["name", "description", "created_at", "updated_at"]
  end

  # CSVをエクスポート
  # sendメソッド:レシーバの持っているメソッドを呼び出し、そのメソッドの戻り値を返す。
  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      all.each do |task| # allメソッドで全タスクを取得し、1レコードごとにCSVを一行出力している。
        csv << csv_attributes.map{|attr| task.send(attr)}
      end
    end
  end

  #CSVをインポート
  #CSV.foreachを使って、CSVファイルを一行ずつ読み込む。headers: trueの指定により、1行目をヘッダとして無視するようにしている。
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      task = new # selfがクラスになるので、Task.newとせず、newと省略している。
      #余計な属性のものをインポートしないようにsliceを使っている
      #slice("name","description","created_at","updated_at")と一緒
      task.attributes = row.to_hash.slice(*csv_attributes)
      task.save!
    end
  end

	private

	def validate_name_not_including_comma
		errors.add(:name, "にカンマを含めることはできません") if name&.include?(",")
	end

	# def set_nameless_name
	# 	self.name = "名前無し" if name.blank?
	# end
end
