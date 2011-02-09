var current_path = window.location.pathname;

function get_user_activity(user_name, url, delay) {
  $.ajax({
    type: "GET",
    url: "/admin/user_activity/" + user_name,
    data: { 
      url : current_path,
      authenticity_token: $('meta[name=csrf-token]').attr('content')
    },
    success: function(data){
      $('#user_activity').html(data);
      
      setTimeout('get_user_activity(\''+ user_name +'\', \''+ url +'\', \''+ delay +'\')', delay);
    }
  });
}


function update_user_activity(user_name, url, delay) {
  $.ajax({
    type: "PUT",
    url: "/admin/user_activity/" + user_name,
    data: ({ 
      url : current_path,
      authenticity_token: $('meta[name=csrf-token]').attr('content')
    }),
    success: function(data){
      setTimeout('update_user_activity(\''+ user_name +'\', \''+ url +'\', \''+ delay +'\')', delay);
    }
  });
}