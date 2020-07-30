<%@ page import="java.util.List" %>
<%@ page import="pojo.User" %><%--
  Created by IntelliJ IDEA.
  User: 93586
  Date: 2020/7/30
  Time: 9:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的好友</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>

<%
    if(session.getAttribute("userName")==null){
        response.getWriter().write("<script>alert(\"请先登录！\");window.location='login.jsp';</script>");
    }
    else if(request.getAttribute("myFriend")==null) {
        request.getRequestDispatcher("myFriend.user").forward(request,response);
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

<div style="margin-left: 50px;margin-bottom: 20px">
    <h2>收到的好友申请：</h2>
    <%
        List<User> invitation = (List<User>) request.getAttribute("invitation");
        if(invitation!=null){
            for(User user:invitation){
    %>
    <div>
        用户名:<%=user.getUserName()%>&nbsp;&nbsp;&nbsp;&nbsp;邮箱:<%=user.getEmail()%>&nbsp;&nbsp;&nbsp;&nbsp;注册时间:<%=user.getDateJoined()%>&nbsp;&nbsp;
        <a href="receiveOrReject.user?ifReceive=true&uid=<%=user.getUid()%>"><input type="button" value="接受"></a>&nbsp;&nbsp;
        <a href="receiveOrReject.user?ifReceive=false&uid=<%=user.getUid()%>"><input type="button" value="拒绝"></a>
    </div>
    <%
            }
        }
    %>
</div>

<form style="margin-left: 50px" action="searchUser.user" method="post">
    <input type="text" name="str" required>
    <input type="submit" value="搜索用户">
</form>

<%
    List<User> searchUsers = (List<User>) request.getAttribute("searchFriend");
    if(searchUsers!=null){
        for(User user:searchUsers){
%>
<div style="margin-left: 50px;margin-top: 10px">
    用户名：<%=user.getUserName()%>&nbsp;&nbsp;&nbsp;&nbsp;邮箱：<%=user.getEmail()%>&nbsp;&nbsp;&nbsp;&nbsp;注册时间：<%=user.getDateJoined()%>&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="invite.user?uid=<%=user.getUid()%>"><input type="button" value="发送好友申请"></a>
</div>
<%
        }
    }
%>

<div style="margin-left: 50px">
    <h2>我的好友：</h2>
    <%
        List<User> myFriend = (List<User>) request.getAttribute("myFriend");
        if(myFriend!=null){
            for(User user:myFriend){
    %>
    <div>
        用户名：<%=user.getUserName()%>&nbsp;&nbsp;&nbsp;&nbsp;邮箱：<%=user.getEmail()%>&nbsp;&nbsp;&nbsp;&nbsp;注册时间：<%=user.getDateJoined()%>&nbsp;&nbsp;&nbsp;&nbsp;
        <a href="friendFavor.image?uid=<%=user.getUid()%>"><input type="button" value="查看TA的收藏"></a>
    </div>
    <%
            }
        }
    %>
</div>

</body>
</html>
