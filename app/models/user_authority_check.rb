class UserAuthorityCheck < AuthorityCheck
  
  def manage_users?
    unless (@user.is_admin?)
      fail!("You don't have permission do manage users.") 
    end
  end
  
  def manage_areas?
    unless (@user.is_admin?)
      fail!("You don't have permission do manage users.") 
    end
  end
end