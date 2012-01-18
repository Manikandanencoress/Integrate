module InvitationHelper
  def redeem_invitation_url(invitation)
    new_admin_registration_url(:token => invitation.token, :protocol => "https://")
  end
end