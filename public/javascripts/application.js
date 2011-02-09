$(document).ready(function() {
  $('input[name=select_all]').change(function(){
    $(this).parents('.posts').find('input[name=posts[]]').attr('checked', $(this).is(':checked'));
  })
  
  $('.post h6').live('click', function(e) {
    e.preventDefault();
    $(this).siblings('.text').toggle();
  })
  
  $('#add_posts').click(function(){
    $.post(
      '/admin/areas/'+$(this).attr('data-area')+'/issues/'+$(this).attr('data-issue')+'/add_posts',
      $("#new_posts").find('input[name=posts[]]').serialize()
    )
  })
  $('#remove_posts').click(function(){
    $.post(
      '/admin/areas/'+$(this).attr('data-area')+'/issues/'+$(this).attr('data-issue')+'/remove_posts',
      $("#issue_posts").find('input[name=posts[]]').serialize()
    )
  })
})

function move_posts_to(posts, dest_div) {
  $.each(posts, function(i, post) {
    $('#post_'+post).detach().appendTo(dest_div);
    $('input[type=checkbox]').attr('checked', false)
    if($('#new_posts').children('.post').length>0)
        $('#add_posts').show();
      else
        $('#add_posts').hide();
    if($('#issue_posts').children('.post').length>0)
        $('#remove_posts').show();
      else
        $('#remove_posts').hide();
  })
}
