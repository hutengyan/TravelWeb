
<%--
  Created by IntelliJ IDEA.
  User: 93586
  Date: 2020/7/13
  Time: 0:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>首页</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet"type="text/css" href="banner.css"/>
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>

<%
    if(request.getAttribute("mostpopular")==null){
%>
<script>
    window.location.href = "/indexImg.image";
</script>
<%
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
                        <li><a href="upload.jsp">上传</a></li>
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

<div class="main" id="main">
    <!--图片轮播-->
    <div class="banner" id="banner">
        <a href="/detail.image?path=${requestScope.mostpopular[0]}">
            <div class="banner-slide slide-active" style="background-size: 100% 100%;background-image: url(${"/resources/travel-images/large/".concat(requestScope.mostpopular[0])})"></div>
        </a>
        <a href="/detail.image?path=${requestScope.mostpopular[1]}">
            <div class="banner-slide" style="background-size: 100% 100%;background-image: url(${"/resources/travel-images/large/".concat(requestScope.mostpopular[1])}"></div>
        </a>
        <a href="/detail.image?path=${requestScope.mostpopular[2]}">
            <div class="banner-slide" style="background-size: 100% 100%;background-image: url(${"/resources/travel-images/large/".concat(requestScope.mostpopular[2])}"></div>
        </a>
    </div>
    <!--上一张下一张按钮-->
    <a href="javascript:void(0)"class="button prev" id="prev"></a>
    <a href="javascript:void(0)"class="button next" id="next"></a>
    <!--原点导航-->
    <div class="dots" id="dots">
        <span class="active"></span>
        <span ></span>
        <span ></span>
    </div>

</div>
<script src="banner.js"></script>

<div>
    <div style="float:left;margin-left: 100px;width: 300px">
        <a href="/detail.image?path=${requestScope.mostnew[0].path}"><img style="height: 250px;width: 250px" src= ${"/resources/travel-images/large/".concat(requestScope.mostnew[0].path)}><br></a>
        <p>
            作者：${requestScope.mostnew[0].userName}<br>
            主题：${requestScope.mostnew[0].content}<br>
            发布时间：${requestScope.mostnew[0].dateUploaded}<br>
        </p>
    </div>
    <div style="float:left;margin-left: 100px;width: 300px">
        <a href="/detail.image?path=${requestScope.mostnew[1].path}"><img style="height: 250px;width: 250px" src= ${"/resources/travel-images/large/".concat(requestScope.mostnew[1].path)}><br></a>
        <p>
            作者：${requestScope.mostnew[1].userName}<br>
            主题：${requestScope.mostnew[1].content}<br>
            <fmt:formatDate value="${requestScope.mostnew[1].dateUploaded}" type="both"/>
            发布时间：${requestScope.mostnew[1].dateUploaded}<br>
        </p>
    </div>
    <div style="float:left;margin-left: 100px;width: 300px">
        <a href="/detail.image?path=${requestScope.mostnew[2].path}"><img style="height: 250px;width: 250px" src= ${"/resources/travel-images/large/".concat(requestScope.mostnew[2].path)}><br></a>
        <p>
            作者：${requestScope.mostnew[2].userName}<br>
            主题：${requestScope.mostnew[2].content}<br>
            发布时间：${requestScope.mostnew[2].dateUploaded}<br>
        </p>
    </div>
</div>

</body>
</html>
