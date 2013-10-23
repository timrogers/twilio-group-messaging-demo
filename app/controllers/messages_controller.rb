class MessagesController < ApplicationController
	respond_to :xml, only: [:sms]

	def sms
		if params[:Body] == "JOIN" || params[:Body] == "join"
			if Member.create(phone_number: params[:From])
				@message = "You've successfully joined the group."
			else
				@message = "Sorry, something went wrong. Are you already a member?"
			end
		elsif params[:Body] == "STOP"
			if member = Member.find_by_phone_number(params[:From])
				member.destroy
				@message = "You have been unsubscribed. Sorry to see you go!"
			else
				@message = "Sorry, you couldn't be unsubscribed. Are you sure you're a member?"
			end
		else
			@message = "Sorry, I didn't understand your message"
		end

		render "sms.xml"
  end

  def new
  end

  def create
  	phone_numbers = Member.all.map(&:phone_number)

  	phone_numbers.each do |number|
			message = client.account.messages.create(
  			to: number,
  			body: params[:message],
  			from: "+441290211999"
  		)
  		Rails.logger.info message.inspect
  	end

  	redirect_to root_path
  end

  def client
  	@client ||= Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_AUTH_TOKEN']
  end
end
