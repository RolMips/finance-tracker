# frozen_string_literal: true

module ApplicationHelper
  def refresh_turbo_flash_messages(path)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream.update('flash_messages', partial: 'layouts/messages')
      end
      format.html { redirect_to path }
    end
  end
end
