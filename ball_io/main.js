         var bound = false;
  
        function bindJavascript() {
           var pjs = Processing.getInstanceById('ball_io');
           if(pjs!=null) {
             pjs.bindJavascript(this);
             bound = true;
           }
           if(!bound) setTimeout(bindJavascript, 250);
        }
  
        bindJavascript();

        function postHighScore(hs) {
            $.post( "save.php", { score: hs } );
        }