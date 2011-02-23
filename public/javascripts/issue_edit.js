$(document).ready(function() {
  current_path = window.location.pathname;
  area_id = current_path.split('/')[3];
  issue_id = current_path.split('/')[5];
  issue_path = current_path.replace('edit', '');
  
  $('input[name=select_all]').change(function(){
    $(this).parents('.posts').find('input[name=posts[]]').attr('checked', $(this).is(':checked'));
  })
  
  $('.post h6').live('click', function(e) {
    e.preventDefault();
    $(this).siblings('.text').toggle();
  })
  
  $('.move_posts').click(function(){
    $.post(
      issue_path+$(this).attr('id'),
      $(this).siblings('.posts').find('input[name=posts[]]').serialize()
    )
  })
  
  $('.ajax-button').live("ajax:beforeSend", function(){
    $(this).replaceWith($('<div class="ajax-loader" id="'+this.id+'">'));
  })

  $('div.sortable').sortable({
    items: 'div.post',
    axis: 'y',
    handle: 'div.status',
    update: function() {
      $.post(
        '/admin/areas/'+area_id+'/posts/order',
        '_method=put&'+$(this).sortable('serialize')
      )
    }
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
