package servlet;

import DAO.ImageDao;
import DAO.UserDao;
import pojo.Image;
import pojo.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

@WebServlet(name = "ImageServlet",urlPatterns = "*.image")
public class ImageServlet extends HttpServlet {
    private UserDao userDao = new UserDao();
    private ImageDao imageDao = new ImageDao();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        String method = path.substring(1,path.length()-6);
        if(method.equals("indexImg"))
            indexImg(request,response);
        if(method.equals("detail"))
            detail(request,response);
        if(method.equals("search"))
            search(request,response);
        if(method.equals("myImg"))
            myImg(request,response);
        if(method.equals("delete"))
            delete(request,response);
        if(method.equals("favor"))
            favor(request,response);
        if(method.equals("myFavor"))
            Myfavor(request,response);
        if(method.equals("favorState"))
            favorState(request,response);
        if(method.equals("friendFavor"))
            friendFavor(request,response);
        if(method.equals("upload"))
            upload(request,response);
        if(method.equals("update"))
            update(request,response);
        if(method.equals("gotoUpdate"))
            gotoUpdate(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }

    private void indexImg(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("index img servlet");
        request.setAttribute("mostpopular",imageDao.findMostPopularImg());
        request.setAttribute("mostnew",imageDao.findMostNewImg());
        request.getRequestDispatcher("index.jsp").forward(request,response);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("detail servlet");
        String path = request.getParameter("path");
        if(path!=null){
            String userName = (String) request.getSession().getAttribute("userName");
            if(userName==null)
                request.setAttribute("collect","登录后可收藏");
            else {
                boolean ifCollect = imageDao.ifCollect(path,userName);
                if(ifCollect)
                    request.setAttribute("collect","取消收藏");
                else
                    request.setAttribute("collect","收藏");
            }
            request.setAttribute("image",imageDao.findImgByPath(path));
            request.getRequestDispatcher("details.jsp").forward(request,response);
        }else {
            request.getRequestDispatcher("index.jsp").forward(request,response);
        }
    }

    private void search(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("search servlet");
        String str = request.getParameter("str");
        String select = request.getParameter("select");
        String sort = request.getParameter("sort");
        request.setAttribute("images",imageDao.returnSearchResult(str,select,sort));
        request.setAttribute("str",str);
        request.setAttribute("select",select);
        request.setAttribute("sort",sort);
        request.getRequestDispatcher("search.jsp").forward(request,response);
    }

    private void myImg(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("myImg servlet");
        String userName = (String) request.getSession().getAttribute("userName");
        if(userName!=null){
            request.setAttribute("myImg",imageDao.findMyImgByUserName(userName));
            request.getRequestDispatcher("myImg.jsp").forward(request,response);
        }else {
            request.getRequestDispatcher("index.jsp").forward(request,response);
        }
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("delete servlet");
        String truePath = "D:\\大二下\\卓越软件开发基础\\project\\out\\artifacts\\0710_war_exploded\\resources\\travel-images\\large\\"+ request.getParameter("path");
        deleteFile(truePath);
        boolean result = imageDao.deleteImg(request.getParameter("path"));
        if(!result)
            request.setAttribute("message","删除失败");
        response.sendRedirect("myImg.jsp");
    }

    //改变收藏状态
    private void favor(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        System.out.println("favor servlet");
        String page = request.getParameter("page");
        String path = request.getParameter("path");
        String userName = (String) request.getSession().getAttribute("userName");
        if(userName==null){
            response.sendRedirect("login.jsp");
            return;
        }
        boolean ifCollect = imageDao.ifCollect(path,userName);
        boolean result = false;
        if(ifCollect){
            result = imageDao.unFavor(path,userName);
            imageDao.changeHeat(-1,path);
        }
        else{
            result = imageDao.beFavor(path,userName);
            imageDao.changeHeat(1,path);
        }
        System.out.println("here");
        if(result){
            request.getRequestDispatcher("/"+page+".image").forward(request,response);
//            response.sendRedirect("/"+page+".image?path="+path);
        }else {
            request.getRequestDispatcher("index.jsp").forward(request,response);
        }
    }

    //显示我的收藏
    private void Myfavor(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("myfavor servlet");
        String userName = (String) request.getSession().getAttribute("userName");
        request.setAttribute("myFavor",imageDao.findMyFavorByUserName(userName));
        int state = userDao.findUserByUserName(userName).getState();
        if(state==1)
            request.setAttribute("favorState","好友可见");
        if(state==-1)
            request.setAttribute("favorState","好友不可见");
        request.getRequestDispatcher("myFavor.jsp").forward(request,response);
    }

    //改变收藏可见状态
    private void favorState(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("favorState servlet");
        String userName = (String) request.getSession().getAttribute("userName");
        if(userDao.changeFavorState(userName)){
            response.sendRedirect("myFavor.jsp");
        }
    }

    private void friendFavor(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        System.out.println("friend favor servlet");
        int uid = Integer.parseInt(request.getParameter("uid"));
        User user = userDao.findUserByUID(uid);
        request.setAttribute("friendName",user.getUserName());
        if(user.getState()==1){
            request.setAttribute("state",1);
            request.setAttribute("FriendFavor",imageDao.findMyFavorByUserName(user.getUserName()));
            System.out.println("here");
            request.getRequestDispatcher("friendFavor.jsp").forward(request,response);
        }else if(user.getState()==-1){
            System.out.println("here");
            request.setAttribute("state",-1);
            request.getRequestDispatcher("friendFavor.jsp").forward(request,response);
        }
    }

    private void upload(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        System.out.println("upload servlet");
        String truePath = request.getParameter("truePath");
        truePath = truePath.substring(truePath.lastIndexOf('\\')+1);
        truePath = "D:\\大二下\\卓越软件开发基础\\project\\web\\test\\"+truePath;
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String description = request.getParameter("description");
        String country = request.getParameter("country");
        String city = request.getParameter("city");
        String userName = (String) request.getSession().getAttribute("userName");
        //获取系统当前时间并将其转换为string类型,生成newPath
        Calendar calendar = Calendar.getInstance();
        Date time = calendar.getTime();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss");
        String fileName = format.format(time);
        int index = truePath.lastIndexOf('.');
        String type = truePath.substring(index+1);
        String newPath = "D:\\大二下\\卓越软件开发基础\\project\\out\\artifacts\\0710_war_exploded\\resources\\travel-images\\large\\"+ fileName+"."+type;
        copy(truePath,newPath,8192);
        String path = fileName+"."+type;
        imageDao.addImage(title,content,description,country,city,userName,path);
        response.sendRedirect("upload.jsp");
    }

    private void update(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException{
        System.out.println("update servlet");
        int ImageID = Integer.parseInt(request.getParameter("ImageID"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String description = request.getParameter("description");
        String country = request.getParameter("country");
        String city = request.getParameter("city");
        boolean result = imageDao.changeImage(title,content,description,country,city,ImageID);
        if(result)
            response.sendRedirect("myImg.jsp");
    }

    private void gotoUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int ImageID = Integer.parseInt(request.getParameter("ImageID"));
        Image image = imageDao.findImgByID(ImageID);
        request.setAttribute("changeImage",image);
        request.getRequestDispatcher("update.jsp").forward(request,response);
    }

    private  void copy(String source, String dest, int bufferSize) throws IOException {
        InputStream in = null;
        OutputStream out = null;
        try {
            in = new FileInputStream(new File(source));
            out = new FileOutputStream(new File(dest));
            byte[] buffer = new byte[bufferSize];
            int len;
            while ((len = in.read(buffer)) > 0) {
                out.write(buffer, 0, len);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                in.close();
            } catch (IOException e) {
                e.printStackTrace();
            }finally {
                out.close();
            }
        }
    }

    private static void deleteFile(String path){
        File file = new File(path);
         if(file.isFile())
             file.delete();
    }
}

