function tab2space(){
  var s = $('#note-content').val();
  s = s.replace(/\t/gm,'  ');
  $('#note-content').val(s);
}
