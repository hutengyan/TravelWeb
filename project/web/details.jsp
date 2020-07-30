<%@ page import="java.util.List" %>
<%@ page import="pojo.Image" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>详情</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>

<nav class="navbar navbar-inverse" role="navigation">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">Welcome</a>
        </div>
        <div>
            <ul class="nav navbar-nav navbar-right">
                <li><a href="index.jsp">首页</a></li>
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

<%
    if(request.getSession().getAttribute("history")!=null){
        List<Image> historyList = (List<Image>) request.getSession().getAttribute("history");
        Image image = (Image) request.getAttribute("image");
        for(Image temp:historyList){
            if(temp.getImageID()==image.getImageID())
                historyList.remove(temp);
        }
        if(historyList.size()<10)
            historyList.add(image);
        if(historyList.size()>=10){
            historyList.remove(0);
            historyList.add(image);
        }
        request.getSession().setAttribute("history",historyList);
    }
%>

<h2 style="margin-left: 80px;margin-top: 30px">图片详情：</h2><br>

<div>
    <img style="margin-left:80px;height: 450px;width: 550px;margin-bottom: 100px" src=${"/resources/travel-images/large/".concat(requestScope.image.path)}>
    <div style="margin-left: 750px;margin-top: -540px">
    <p>作者：${requestScope.image.userName}</p><br>
    <p>标题：${requestScope.image.title}</p><br>
    <p>图片主题：${requestScope.image.content}</p><br>
    <p>简介：${requestScope.image.description}</p><br>
    <p>热度：${requestScope.image.heat}</p><br>
    <p>国家：${requestScope.image.countryName}</p><br>
    <p>城市：${requestScope.image.cityName}</p><br>
    <p>发布时间：${requestScope.image.dateUploaded}</p><br>
    <a href="/favor.image?page=detail&path=${requestScope.image.path}"><input type="button" value=${requestScope.collect}></a>
    </div>
</div>



</body>
</html>
