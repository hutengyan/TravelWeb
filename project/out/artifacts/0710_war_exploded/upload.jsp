<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>上传</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script>
        function xmTanUploadImg(obj) {
            var truePath = document.getElementById('truePath');
            truePath.value = document.getElementById('uploadImg').value;
            var file = obj.files[0];
            var reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onload = function (e) {    //成功读取文件
                var img = document.getElementById("selectImg");
                img.src = e.target.result;
                img.style = "height: 200px;width: 200px;";
            };
        }

        function confirmUpload() {
            var confirm = window.confirm("确认信息是否完整无误？");
            var form = document.getElementById("form");
            if(confirm){
                form.submit();
            }else
                return false;
        }
    </script>
</head>
<body onload="loadCountries();">

<%
    if(session.getAttribute("userName")==null) {
        response.getWriter().write("<script>alert(\"请先登录！\");window.location='login.jsp';</script>");
    }
%>

<nav class="navbar navbar-inverse" role="navigation">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">Welcome</a>
        </div>
        <div>
            <ul class="nav navbar-nav navbar-right">
                <li class="active"><a href="index.jsp">首页</a></li>
                <li><a href="search.jsp">搜索</a></li>
                <%
                    if(session.getAttribute("userName")==null){
                %>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        未登录 <b class="caret"></b>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="login.jsp">登录</a></li>
                        <li><a href="register.jsp">注册</a></li>
                    </ul>
                </li>
                <%
                }else{
                %>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        ${sessionScope.userName} <b class="caret"></b>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="myFavor.jsp">我的收藏</a></li>
                        <li class="active"><a href="upload.jsp">上传</a></li>
                        <li><a href="myImg.jsp">我的图片</a></li>
                        <li><a href="myFriend.jsp">我的好友</a></li>
                        <li class="divider"></li>
                        <li><a href="/logout.user">退出登录</a></li>
                    </ul>
                </li>
                <%
                    }
                %>
            </ul>
        </div>
    </div>
</nav>

<form style="margin-left: 100px" id="form" action="/upload.image" method="post">
    <div class="form-group">
    图片：<input type="file" id="uploadImg" name="path" accept="image/jpg, image/png, image/jpeg" enctype="multipart/form-data" required onchange="xmTanUploadImg(this)">
    <input type="text" id="truePath" name="truePath" value="" >
    </div>
        <div class="form-group">
    预览：<img src="" alt="" id="selectImg"><br>
        </div>
    <div class="form-group">
    标题：<input type="text" name="title" required><br>
    </div>
    <div class="form-group">
    主题：<input type="text" name="content" required><br>
    </div>
    <div class="form-group">
    简介：<input type="text" name="description" required><br>
    </div>
    <div class="form-group">
    国家：<select id="country" name="country" onchange="loadCities(this.value)" required>
    <option value="" disabled selected>--请选择国家--</option>
    </select><br>
    </div>
    <div class="form-group">
    城市：<select name="city" id="city">
        <option>--请选择城市--</option>
    </select><br>
    </div>
    <%--<input type="submit" value="上传" onsubmit="confirmUpload();">--%>
    <a onclick="confirmUpload();"><input style="margin-left: 200px" type="button" value="上传"></a><br>
</form>



<script>
    function loadCountries() {
        $.ajax({
            url:'country.geo',
            type:'POST',
            dataType:"json",    //数据类型为json格式
            contentType: "application/x-www-form-urlencoded;charset=UTF-8",
            success(data){
                if(data.hasOwnProperty('country')){
                    var countries = data.country;
                    var countrySelector = $('#country');
                    countries.forEach(function (country) {
                        countrySelector.append("<option value='"+ country +"'>"+ country +"</option>");
                    })
                }
            }
        })
    }
    function loadCities(countryName) {
        $.ajax({
            url:'city.geo',
            type:'POST',
            data:{
                "countryName":countryName
            },
            dataType:"json",    //数据类型为json格式
            contentType: "application/x-www-form-urlencoded;charset=UTF-8",
            success(data){
                if(data.hasOwnProperty('city')){
                    console.log(data.city);
                    var cities = data.city;
                    var citySelector = $('#city');
                    citySelector.empty();
                    cities.forEach(function (city) {
                        citySelector.append("<option value='"+ city +"'>"+ city +"</option>");
                    })
                }
            }
        })
    }
</script>


</body>
</html>
