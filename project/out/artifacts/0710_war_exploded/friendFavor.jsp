<%@ page import="pojo.Image" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: 93586
  Date: 2020/7/30
  Time: 9:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>好友收藏</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>

<%
    if(session.getAttribute("userName")==null){
        response.getWriter().write("<script>alert(\"请先登录！\");window.location='login.jsp';</script>");
    }else if(request.getAttribute("state")==null) {
        request.getRequestDispatcher("myFriend.jsp").forward(request,response);
    }
%>

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
                        <li class="active"><a href="myFriend.jsp">我的好友</a></li>
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

<h2 style="margin-left: 50px;margin-bottom: 20px">${requestScope.friendName}的收藏</h2>

<%
    if((int)request.getAttribute("state")==1){
        List<Image> images = (List<Image>) request.getAttribute("FriendFavor");
        if(images!=null){
            for(Image image:images){
%>
<div style="float:left;margin-left: 100px;width: 300px">
    <a href="/detail.image?path=<%=image.getPath()%>"><img style="height: 250px;width: 250px" src=<%="/resources/travel-images/large/"+image.getPath()%>><br></a>
    <p>标题：<%=image.getTitle()%></p>
</div>
<%
        }
    }}else {
%>
<h3 style="margin-left: 150px;margin-top: 50px;color: lightslategray">好友设置了不可查看收藏</h3>
<%
    }
%>

</body>
</html>
