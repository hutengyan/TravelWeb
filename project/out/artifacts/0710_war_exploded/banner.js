function byId(id){
    return typeof(id) === "string"?document.getElementById(id):id;
}

//全局变量
var index = 0,
    timer= null,
    pics= byId("banner").getElementsByTagName("div"),
    dots= byId("dots").getElementsByTagName("span"),
    prev= byId("prev"),
    next= byId("next"),
    len= pics.length;              //因为图片数和小点数一样所以获取其中一个的数量就可以了

function slideImg(){
    var main = byId("main");
    //鼠标滑过清除定时器，离开后继续
    main.onmouseover = function(){
        //滑过清除定时器
        if (timer) {
            clearInterval(timer);
        }
    };

    main.onmouseout = function(){
        timer = setInterval(function(){
            index++;
            if (index >= len) {
                index= 0;
            }
            //切换图片
            changeImg();
        },3000);
    };

    //自动在main上出发鼠标离开的事件
    main.onmouseout();

    //遍历所有点击，切绑定点击事件，点击圆点切换图片
    for (var d=0;d<len;d++) {

        //给所有span添加一个id的属性，值为当前span的索引
        dots[d].id = d;
        dots[d].onclick = function(){
            //改变index为当前span的索引（不能用d，因为d在function中为最终值：3)
            index = this.id;
            //调用changeImg实现切换图片
            changeImg();
        }
    }

    //上一张
    prev.onclick = function(){
        index--;
        if(index<0){index = len-1;}
        changeImg();
    };

    //下一张
    next.onclick = function(){
        index++;
        if(index>=len){index = 0;}
        changeImg();
    }
}


//封装切换图片
function changeImg(){
    //遍历banner下所有的div及dots下的所有的span，将其隐藏
    for (var i = 0;i<len;i++) {
        pics[i].style.display = "none";
        dots[i].className= "";
    }
    //根据index索引找到当前div和当前span，电器显示出来和设为当前
    pics[index].style.display = "block";
    dots[index].className= "active";
}

slideImg();