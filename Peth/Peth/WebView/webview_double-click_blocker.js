
"use strict";

(() => {
    document.addEventListener('touchstart',function (event) {
        if(event.touches.length>1){
            event.preventDefault();
        }
    });

    let lastTouchEnd=0;

    document.addEventListener('touchend',function (event) {
        var now=(new Date()).getTime();
        if(now-lastTouchEnd<=300){
            event.preventDefault();
        }
        lastTouchEnd=now;
        
    },false);

    document.addEventListener('gesturestart', function (event) {
        event.preventDefault();
    });
  var peth = function(){};
  peth.call = function(resuest){
    window.webkit.messageHandlers.vueCall.postMessage(resuest);
  }
  peth.handle = function(response){
    window.webkit.messageHandlers.vuehandle.postMessage(response);
  }
  window.wallet = wallet;
})()
