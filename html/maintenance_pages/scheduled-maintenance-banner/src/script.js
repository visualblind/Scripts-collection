if (sessionStorage.getItem('notificationBar') != 1) {
  showNotificationBar();
}

$('.notification-bar').find('.close').click(function(){
  sessionStorage.setItem('notificationBar', 1);
  hideNotificationBar();
})

function showNotificationBar(){
  $('.notification-bar').show()
}

function hideNotificationBar(){
  $('.notification-bar').slideUp()
}

//Testing only
$('.reset').click(function(){
  sessionStorage.setItem('notificationBar', 0);
  $('.notification-bar').show()
})