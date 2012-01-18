class InvitationMailer < ActionMailer::Base
  helper :invitation
  default :from => "admin@milyoni.net"
  
  def invite invitation
    @invitation = invitation
    mail(:to => invitation.email)
  end
end