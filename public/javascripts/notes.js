function tab2space(){
  var s = $('#note-content').val();
  alert(s);
  s = s.replace(/\t/gm,'  ');
  $('#note-content').val(s);
}
