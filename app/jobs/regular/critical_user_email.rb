# frozen_string_literal: true

module Jobs
  class CriticalUserEmail < UserEmail

    sidekiq_options queue: 'critical'

    def quit_email_early?
      false
    end

    def execute(args)
      super(args)
      Rails.logger.info "[email debug] critical user email execute"
    end
  end
end
