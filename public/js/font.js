function resize() {
  var $resizeText = $('.js-resize-text');
  $resizeText.each(function() {
    var wrapper = $(this).width() / $('body').width();
    var fontSizeVw = wrapper / $(this).text().length;
    // ▼ letter-spacingを0.1emに指定していた場合、1.1をかける
    // var fontSizeVw = wrapper / ($(this).text().length * 1.1);
    $(this).css('font-size', fontSizeVw * 100 + 'vw');
  });
}
// 初期
window.onload = function(){
  resize();
}
// リサイズした時
window.onresize = function(){
  resize();
}