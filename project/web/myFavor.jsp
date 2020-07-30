<%@ page import="pojo.Image" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: 93586
  Date: 2020/7/30
  Time: 7:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的收藏</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body onload="display(1)">

<%
    if(session.getAttribute("userName")==null){
        response.getWriter().write("<script>alert(\"请先登录！\");window.location='login.jsp';</script>");
    }else if(request.getAttribute("myFavor")==null) {
        request.getRequestDispatcher("myFavor.image").forward(request,response);
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
                        <li class="active"><a href="myFavor.jsp">我的收藏</a></li>
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

<h2 style="margin-left: 50px;margin-bottom: 20px">我的足迹</h2>
<div style="margin-left: 50px">
<%
    if(request.getSession().getAttribute("history")!=null){
        List<Image> historyList = (List<Image>) request.getSession().getAttribute("history");
        for(Image temp:historyList){
            %>
<a class="col-sm-3" style="margin-top: 10px;margin-bottom: 10px;margin-left: 10px" href="/detail.image?path=<%=temp.getPath()%>"><%=temp.getTitle()%></a>
<%
        }
    }
%>
</div>
<div class="pull-right" style="width:100%">
<h2 style="margin-left: 50px;margin-bottom: 20px">我的收藏</h2>
<a href="/favorState.image"><input style="margin-left: 1100px;margin-bottom: 20px" type="button" value=${requestScope.favorState}></a>
</div>
<div style="width: 100%">
<%
    List<Image> images = (List<Image>) request.getAttribute("myFavor");
    int pages=0;
    if(images!=null){
        if(images.size()%9==0)
            pages = images.size()/9;
        else
            pages = images.size()/9+1;
        int current = 1;//第几页
        int i;
        for(i=0;i<pages-1;i=i+9){
            for(int j=0;j<9;j++){
                Image image = images.get(i*9+j);{
%>
<div style="float:left;margin-left: 100px;width: 300px" name=<%=current%> style="display:none">
    <a href="/detail.image?path=<%=image.getPath()%>"><img style="height: 250px;width: 250px" src=<%="/resources/travel-images/large/"+image.getPath()%>><br></a>
    <p>标题：<%=image.getTitle()%></p>
    <a href="/favor.image?page=myFavor&path=<%=image.getPath()%>"><input type="button" value="取消收藏"></a>
</div>
<%
            }
        }
        current++;
    }
    for(i=i*9;i<images.size();i++){
        Image image = images.get(i);
%>
<div style="float:left;margin-left: 100px;width: 300px" name=<%=pages%> style="display:none">
    <a href="/detail.image?path=<%=image.getPath()%>"><img style="height: 250px;width: 250px;margin-bottom: 10px" src=<%="/resources/travel-images/large/"+image.getPath()%>><br></a>
    <p>标题：<%=image.getTitle()%></p>
    <a href="/favor.image?page=myFavor&path=<%=image.getPath()%>"><input type="button" value="取消收藏"></a>
</div>
<%
        }
    }
%>
</div>
<div style="float:left;width: 100%;margin-bottom: 20px;margin-top: 10px">
    <div style="margin-right: 50px;float: right;margin-bottom: 20px;margin-top: 10px">
<%
    for(int i=1;i<pages+1;i++){
%>
<input type="button" id="<%=""+i%>" value=<%=""+i%> onclick="display(this.id)">
<%
    }
%>
    </div>
</div>

<script>
    function display(id) {
        var p = <%= pages%>;
        //先把所有都设置为none
        for(var i=1;i<=p;i++){
            var list = document.getElementsByName(''+i);//style.display="none";
            for(var j=0;j<list.length;j++){
                list[j].style.display="none";
            }
        }
        var showList = document.getElementsByName(''+id);
        for(var k=0;k<showList.length;k++){
            showList[k].style.display="inline";
        }
    }
</script>

<%--<%--%>
    <%--List<Image> images = (List<Image>) request.getAttribute("myFavor");--%>
    <%--if(images!=null){--%>
        <%--for(Image image:images){--%>
<%--%>--%>
<%--<div>--%>
    <%--<a href="/detail.image?path=<%=image.getPath()%>"><img src=<%="/resources/travel-images/large/"+image.getPath()%>><br></a>--%>
    <%--<p>标题：<%=image.getTitle()%></p>--%>
    <%--<a href="/favor.image?page=myFavor&path=<%=image.getPath()%>"><input type="button" value="取消收藏"></a>--%>
<%--</div>--%>
<%--<%--%>
        <%--}--%>
    <%--}--%>
<%--%>--%>

</body>
</html>
