$(document).ready(function() {
  $(document).on('mousedown', '.save-action', function(e) {
    var editor, instance;
    for (instance in CKEDITOR.instances) {
      editor = CKEDITOR.instances[instance];
      if (editor.checkDirty()) {
        editor.updateElement();
      }
    }
    return true;
  });
});
