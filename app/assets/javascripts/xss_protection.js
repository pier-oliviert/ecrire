$(function() {
  var globalFunc = $.globalEval
  $.globalEval = function(data) {
    if (data.slice(0, 8).localeCompare("for(;;);") == 0) {
      data = data.slice(8)
    }
    globalFunc(data)
  }
})

