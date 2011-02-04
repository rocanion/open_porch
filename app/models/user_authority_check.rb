# class UserAuthorityCheck < AuthorityCheck
#   def manage_areas?
#     unless (@user.is_admin?)
#       fail!("Only Admins can manage areas.")
#     end
#   end
#   def manage_users?
#     unless (@user.is_admin?)
#       fail!("Only admins can manage users.")
#     end
#   end
# end

class UserAuthorityCheck < AuthorityCheck
  def wear_shoes?
    unless (@user.is_admin?)
      fail!("Only people with names that start with 'A' can wear shoes.")
    end
  end
end