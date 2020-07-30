package servlet;

import DAO.GeoDao;
import com.alibaba.fastjson.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "GeoServlet",urlPatterns = "*.geo")
public class GeoServlet extends HttpServlet {

    private GeoDao geoDao = new GeoDao();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        String method = path.substring(1,path.length()-4);
        if(method.equals("country"))
            country(request,response);
        if(method.equals("city"))
            city(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }

    private void country(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("country Servlet");
        JSONObject jsonObject = new JSONObject();
        List<String> country =  geoDao.findAllCountry();
        jsonObject.put("country",country);
        response.getWriter().println(jsonObject);
//        request.getRequestDispatcher("upload.jsp").forward(request,response);
    }

    private void city(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("city Servlet");
        String countryName = request.getParameter("countryName");
        JSONObject jsonObject = new JSONObject();
        List<String> city =  geoDao.findCity(countryName);
        jsonObject.put("city",city);
        response.getWriter().println(jsonObject);
//        request.getRequestDispatcher("upload.jsp").forward(request,response);
    }
}
