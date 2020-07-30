<%@ page import="pojo.Image" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: 93586
  Date: 2020/7/29
  Time: 11:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>搜索</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body onload="display(1)">

<nav class="navbar navbar-inverse" role="navigation">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">Welcome</a>
        </div>
        <div>
            <ul class="nav navbar-nav navbar-right">
                <li><a href="index.jsp">首页</a></li>
                <li class="active"><a href="search.jsp">搜索</a></li>
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

<form action="/search.image" method="post" id="form" style="margin-left: 400px">
    <input type="text" name="str" id="str" required value=${requestScope.str}>
    <input type="submit" value="搜索">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    根据标题筛选：<input type="radio" name="select" id="select1" value="title" <%if(request.getAttribute("select")!=null && request.getAttribute("select").equals("title")){%>checked="checked"<%}%> required/>
    根据主题筛选：<input type="radio" name="select" id="select2" value="content" <%if(request.getAttribute("select")!=null && request.getAttribute("select").equals("content")){%>checked="checked"<%}%> required/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    根据热度排序：<input type="radio" name="sort" id="sort1" value="heat" <%if(request.getAttribute("sort")!=null && request.getAttribute("sort").equals("heat")){%>checked="checked"<%}%> required/>
    根据时间排序：<input type="radio" name="sort" id="sort2" value="time" <%if(request.getAttribute("sort")!=null && request.getAttribute("sort").equals("time")){%>checked="checked"<%}%> required/><br>
</form>

<br>
<div>
<%
    List<Image> images = (List<Image>) request.getAttribute("images");
    int pages=0;
    if(images!=null){
        System.out.println(images.size());
        if(images.size()%9==0)
            pages = images.size()/9;
        else
            pages = images.size()/9+1;
        System.out.println(pages);
        int current = 1;//第几页
        int i;
        for(i=0;i<pages-1;i++){
            for(int j=0;j<9;j++){
                Image image = images.get(i*9+j);{
%>
<div style="float:left;margin-left: 100px;width: 300px" name=<%=""+current%> style="display:none">
    <a href="/detail.image?path=<%=image.getPath()%>"><img style="height: 250px;width: 250px" src=<%="/resources/travel-images/large/"+image.getPath()%>><br></a>
    <div>
    <p>作者：<%=image.getUserName()%></p>
    <p>标题：<%=image.getTitle()%></p>
    <p>图片主题：<%=image.getContent()%></p>
    <p>热度：<%=image.getHeat()%></p>
    <p>发布时间：<%=image.getDateUploaded()%></p>
    </div>
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
    <a href="/detail.image?path=<%=image.getPath()%>"><img style="height: 250px;width: 250px" src=<%="/resources/travel-images/large/"+image.getPath()%>><br></a>
    <p>作者：<%=image.getUserName()%></p>
    <p>标题：<%=image.getTitle()%></p>
    <p>图片主题：<%=image.getContent()%></p>
    <p>热度：<%=image.getHeat()%></p>
    <p>发布时间：<%=image.getDateUploaded()%></p><br>
</div>
<%
        }
    }
%>
</div>
<div class="pull-right" style="width: 100%;margin-bottom: 20px;margin-top: 10px">
    <div style="margin-right: 50px;float: right;margin-bottom: 20px">
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



</body>
</html>
