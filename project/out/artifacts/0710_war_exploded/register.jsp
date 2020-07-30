
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>注册</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script>

        var code ; //在全局定义验证码
        //产生验证码
        window.onload = createCode;

        function createCode(){
            code = "";
            var codeLength = 4;//验证码的长度
            var checkCode = document.getElementById("code");
            var random = [0,1,2,3,4,5,6,7,8,9,'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R',
                'S','T','U','V','W','X','Y','Z'];//随机数
            for(var i = 0; i < codeLength; i++) {//循环操作
                var index = Math.floor(Math.random()*36);//取得随机数的索引（0~35）
                code += random[index];//根据索引取得随机数加到code上
            }
            checkCode.value = code;//把code值赋给验证码
        }
        //校验验证码
        function validate(){
            var inputCode = document.getElementById("codeInput").value.toUpperCase(); //取得输入的验证码并转化为大写
            // if(inputCode.length <= 0) { //若输入的验证码长度为0
            //     alert("请输入验证码！"); //则弹出请输入验证码
            // }
            if(inputCode != code ) {
                document.getElementById("codeSpan").style.visibility = "visible";
                document.getElementById("codeInput").value = "";//清空文本框
                return false;
            }
            else {
                document.getElementById("codeSpan").style.visibility = "hidden";
                return true;
            }
        }

        function checkAll() {
            if(checkUserName() & checkPass() & checkEmail() & confirmPassword() & validate()){
                var form = document.getElementById("form");
                form.submit();
            }
            else{
                createCode();//刷新验证码
            }
        }

        //检查用户名格式
        function checkUserName() {
            var reg = /^.{4,15}$/;
            var userName = document.getElementById("userName").value;
            if(!reg.test(userName)){
                document.getElementById("userNameSpan").style.visibility = "visible";
                return false;
            }
            else {
                document.getElementById("userNameSpan").style.visibility = "hidden";
                return true;
            }
        }
        //检查密码格式
        function checkPass() {
            var reg = /^.{6,12}$/;
            var pass = document.getElementById("pass").value;
            if(!reg.test(pass)){
                document.getElementById("passSpan").style.visibility = "visible";
                return false;
            }
            else {
                document.getElementById("passSpan").style.visibility = "hidden";
                return true;
            }
        }
        //检查邮箱格式
        function checkEmail() {
            var reg = /^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/;
            var email = document.getElementById("email").value;
            if(!reg.test(email)){
                document.getElementById("emailSpan").style.visibility = "visible";
                return false;
            }
            else {
                document.getElementById("emailSpan").style.visibility = "hidden";
                return true;
            }
        }
        //确认密码与密码是否一致
        function confirmPassword() {
            var pass = document.getElementById("pass").value;
            var confirmPass = document.getElementById("confirmPass").value;
            if(pass != confirmPass){
                document.getElementById("confirmPassSpan").style.visibility = "visible";
                return false;
            }
            else{
                document.getElementById("confirmPassSpan").style.visibility = "hidden";
                return true;
            }
        }
    </script>
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
                <li class="dropdown active">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        未登录 <b class="caret"></b>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="login.jsp">登录</a></li>
                        <li class="active"><a href="#">注册</a></li>
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

<br>

<%
    String message = (String) request.getAttribute("message");
    if(message!=null){
%>
<script>
    alert("<%= message%>");
</script>
<%
    }
%>

<form style="margin-left: 50px" action="/register.user" method="post" id="form">
    <div class="form-group">
    <label class="col-sm-1">用户名:<br></label>
    <input type="text" placeholder="请输入用户名" name="userName" id="userName" value="${requestScope.userName}" required>
    <span id="userNameSpan" style="visibility: hidden;color: red;margin-left: 10px">用户名长度应在4至15位</span>
    <br>
    </div>
    <div class="form-group">
        <label class="col-sm-1">邮箱:<br></label>
    <input type="text" placeholder="请输入邮箱" name="email" id="email" value="${requestScope.email}" required>
    <span id="emailSpan" style="visibility: hidden;color: red;margin-left: 10px">邮箱格式不正确</span>
    <br>
    </div>
    <div class="form-group">
        <label class="col-sm-1">密码:<br></label>
    <input type="password" placeholder="请输入密码" name="pass" id="pass" value="${requestScope.pass}" required>
    <span id="passSpan" style="visibility: hidden;color: red;margin-left: 10px">密码长度应在6至12位</span>
    <br>
    </div>
    <div class="form-group">
        <label class="col-sm-1">确认密码:<br></label>
    <input type="password" placeholder="请输入确认密码" id="confirmPass" value="${requestScope.pass}" required>
    <span id="confirmPassSpan" style="visibility: hidden;color: red;margin-left: 10px">两次密码输入不一致</span>
    <br>
    </div>
    <div class="form-group">
        <label class="col-sm-1">验证码:<br></label>
    <input type = "text" id = "codeInput" required>
    <input type = "button" id="code" onclick="createCode()">
    <span id="codeSpan" style="visibility: hidden;color: red;margin-left: 10px">验证码错误</span>
    <br>
    </div>
    <input style="margin-left: 250px" type="button" value="提交" onclick="checkAll();">
</form>
</body>
</html>


