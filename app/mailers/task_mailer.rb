class TaskMailer < ApplicationMailer

	# デフォルトで設定する方法もある。
	# defalut from: "taskapp@example.com"

	def creation_email(task)
		@task = task
		mail(
			subject: "タスク作成完了メール",
			to: "user@example.com",
			from: "taskapp@example.com"
		)
	end
end
