package servlet;

import DAO.UserDao;
import pojo.Image;
import pojo.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.LinkedList;

@WebServlet(name = "userServlet",urlPatterns = "*.user")
public class UserServlet extends HttpServlet {

    private UserDao userDao = new UserDao();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String path = request.getServletPath();
        String method = path.substring(1,path.length()-5);
        if(method.equals("login"))
            login(request,response);
        if(method.equals("register"))
            register(request,response);
        if(method.equals("logout"))
            logout(request,response);
        if(method.equals("searchUser"))
            searchUser(request,response);
        if(method.equals("invite"))
            invite(request,response);
        if(method.equals("myFriend"))
            myFriend(request,response);
        if(method.equals("receiveOrReject"))
            receiveOrReject(request,response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        doPost(request,response);
    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        System.out.println("loginServlet");
        String userName = request.getParameter("userName");
        String pass = request.getParameter("pass");
        User user = userDao.findUserByUserNameAndPass(userName,pass);
        if(user!=null){
            request.getSession().setAttribute("userName",userName);
            request.getSession().setAttribute("history",new LinkedList<Image>());
            request.getRequestDispatcher("index.jsp").forward(request,response);
        }
        else{
            request.setAttribute("userName",userName);
            request.setAttribute("pass",pass);
            request.getRequestDispatcher("login.jsp").forward(request,response);
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        System.out.println("registerServlet");
        String userName = request.getParameter("userName");
        String pass = request.getParameter("pass");
        String email = request.getParameter("email");

        //检查用户名是否重复
        User user = userDao.findUserByUserName(userName);
        if(user!=null){
            request.setAttribute("message","用户名重复");
            request.setAttribute("userName",userName);
            request.setAttribute("pass",pass);
            request.setAttribute("email",email);
            request.getRequestDispatcher("register.jsp").forward(request,response);
            return;
        }

        boolean result = userDao.addUser(userName,pass,email);
        if(result){
            request.getSession().setAttribute("userName",userName);
            request.getRequestDispatcher("index.jsp").forward(request,response);
        }
        else{
            request.setAttribute("message","注册失败");
            request.getRequestDispatcher("register.jsp").forward(request,response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getSession().removeAttribute("userName");
        request.getSession().removeAttribute("history");
        request.getRequestDispatcher("index.jsp").forward(request,response);
    }

    private void searchUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("searchUser servlet");
        String str = request.getParameter("str");
        request.setAttribute("searchFriend",userDao.returnSearchUserResult(str));
        request.getRequestDispatcher("myFriend.jsp").forward(request,response);
    }

    private void invite(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String inviteUserName = (String) request.getSession().getAttribute("userName");
        int beinviteUID = Integer.parseInt(request.getParameter("uid"));
        boolean result = userDao.addInvite(inviteUserName,beinviteUID);
        if(result){
            request.getRequestDispatcher("myFriend.jsp").forward(request,response);
        }
    }

    private void myFriend(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String userName = (String) request.getSession().getAttribute("userName");
        request.setAttribute("invitation",userDao.findInvitation(userName));
        request.setAttribute("myFriend",userDao.findFriend(userName));
        request.getRequestDispatcher("myFriend.jsp").forward(request,response);
    }

    private void receiveOrReject(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String ifReceive = request.getParameter("ifReceive");
        String beinviteUserName = (String) request.getSession().getAttribute("userName");
        int inviteUID = Integer.parseInt(request.getParameter("uid"));
        if(userDao.changeInviteState(ifReceive,beinviteUserName,inviteUID)){
            request.getRequestDispatcher("myFriend.jsp").forward(request,response);
        }
    }
}
