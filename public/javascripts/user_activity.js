function get_user_activity(user_name, url, delay) {
  $.ajax({
    type: "GET",
    url: "/admin/user_activity/" + user_name,
    data: { 
      url : url,
      authenticity_token: $('meta[name=csrf-token]').attr('content')
    },
    success: function(data){
      setTimeout('get_user_activity(\''+ user_name +'\', \''+ url +'\', \''+ delay +'\')', delay);
      $('#user_activity').html(data);
    }
  });
}


function update_user_activity(user_name, url, delay) {
  $.ajax({
    type: "PUT",
    url: "/admin/user_activity/" + user_name,
    data: ({ 
      url : url,
      authenticity_token: $('meta[name=csrf-token]').attr('content')
    }),
    success: function(data){
      setTimeout('update_user_activity(\''+ user_name +'\', \''+ url +'\', \''+ delay +'\')', delay);
    }
  });
}