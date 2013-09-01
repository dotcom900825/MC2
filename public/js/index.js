$(function(){
  // $('.gifts').scroll(function(){
  //   var $this = $(this);
  //   var offset = $this.offset(); 
  //   var $window = $(window); 
  //   var doTrigger = $window.scrollTop() + $window.height() >= offset.top + $this.height() + settings.verticalRange && $window.scrollTop() <= offset.top + settings.verticalRange;
  //   console.log(doTrigger);
  // });

  var stop = true;
  var page = 2;
  $(window).scroll(function(){
    totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop());
    if($(document).height() <= totalheight){
      if(stop==true){
        stop=false;
        $.post("/blog/articles/getmoreproject",{page:page,authenticity_token: $('meta[name="csrf-token"]').attr("content")},function(data){
          console.log(data);
          if (data.articles.length != 0) {
            var lis = '';
            $.each(data.articles,function(i,d){
              var li = '<li id="'+d.id+'" class="gift"> \
              <a class="gift-poster" href="/blog/articles/show/'+d.id+'"> \
              <img src="'+d.src+'"> \
              </a> \
              <div class="gift-detail"> \
              <div class="title"> \
              '+d.name+' \
              </div> \
              <div class="labels"> \
              <div class="label label-'+d.category+'"> </div> \
              <span class="follower">+'+d.follow+'关注</span> \
              </div> \
              </div> \
              </li>';
              lis += li;
            });
            $(".loadingmore").before(lis);
            stop=true;
            page++;
          } else {
            $(".loadingmore").hide()
          }
        });
        // $.post("ajax.php", {start:1, n:50},function(txt){
        //   $("#Loading").before(txt);
        //   stop=true;
        // },"text");
        console.log(true);
      }
    }
  });
  
});
