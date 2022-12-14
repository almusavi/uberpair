class BrowseController < ApplicationController

  def browse
    @matches = Match.matches_for( current_account.id )
    @users = Match.recommended_matches_for( current_account.id )
    @conversations = Conversation.includes(:messages).where("conversations.sender_id = ? OR conversations.recipient_id = ?", current_account.id, current_account.id)
  end

  def get_more_users
    # return next 10 users via ajax

  end

  def approve
    account_id = params[:id]
    match = Match.between( account_id, current_account.id )

    if match.present?
      match = match.first

      if match.account_1 == current_account.id
        match.account_1_approves = true
      else
        match.account_2_approves = true
      end
    else
      match = Match.new(account_1: current_account.id, account_2: account_id, account_1_approves: true)
    end

    if match.save
      # show successful save
    else
    end

  end

  def decline
    # user swipes left
    account_id = params[:id]
    match = Match.between( account_id, current_account.id )

    if match.present?
      match = match.first

      if match.account_1 == current_account.id
        match.account_1_approves = false
      else
        match.account_2_approves = false
      end
    else
      match = Match.new(account_1: current_account.id, account_2: account_id, account_1_approves: false)
    end

    if match.save
      # show successful save
    else
    end
  end

  def open_conversation
    id = params[:id]
    @profile = Account.find(id)
    match = Match.between(current_account.id, id)
    @match = match.first if match.present?

    conversation = Conversation.between(id, current_account.id)

    @conversation = conversation.size > 0 ? conversation.first : Conversation.new
    @messages = @conversation.messages.includes(account: :images_attachments) if @conversation.persisted?
    @message = @conversation.messages.build

    if @profile.present?
      # get conversation entries for this user

      respond_to do |format|
        format.js {
          render "browse/conversation"
        }
      end
    end
  end

end
