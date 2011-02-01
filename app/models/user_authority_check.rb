class UserAuthorityCheck < AuthorityCheck
  def wear_shoes?
    unless (@user.is_admin?)
      fail!("Only people with names that start with 'A' can wear shoes.")
    end
  end
end