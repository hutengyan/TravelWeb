package DAO;

import Utils.JDBCTools;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.*;
import pojo.Image;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.LinkedList;
import java.util.List;

public class ImageDao {
    private UserDao userDao = new UserDao();
    private GeoDao geoDao = new GeoDao();
    private QueryRunner queryRunner = new QueryRunner();
    private Connection connection = null;

    public ImageDao() {
    }

    public List<String> findMostPopularImg(){
        String sql = "SELECT * FROM travelimage ORDER BY Heat DESC LIMIT 0,3";
        List<String> result = null;
        try{
            connection = JDBCTools.getConnection();
            result = (List<String>) queryRunner.query(connection,sql,new ColumnListHandler("Path"));
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null, connection);
        }
        return result;
    }

    public List<Image> findMostNewImg(){
        String sql = "SELECT * FROM travelimage ORDER BY DateUploaded DESC LIMIT 0,3";
        List<Image> result = null;
        try{
            connection = JDBCTools.getConnection();
            result = queryRunner.query(connection,sql,new BeanListHandler<Image>(Image.class));
            for(Image image:result){
                image.setUserName(userDao.findUserByUID(image.getuID()).getUserName());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null, connection);
        }
        return result;
    }

    public Image findImgByPath(String path){
        String sql = "SELECT * FROM travelimage WHERE Path=?";
        Image result = null;
        try{
            connection = JDBCTools.getConnection();
            result = queryRunner.query(connection,sql,new BeanHandler<>(Image.class),path);
            result.setUserName(userDao.findUserByUID(result.getuID()).getUserName());
            result.setCountryName(geoDao.findCountryNameByID(result.getCountry_RegionCodeISO()));
            result.setCityName(geoDao.findCityNameByID(result.getCityCode()));
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null, connection);
        }
        return result;
    }

    public Image findImgByID(int imgID){
        String sql = "SELECT * FROM travelimage WHERE ImageID=?";
        Image result = null;
        try{
            connection = JDBCTools.getConnection();
            result = queryRunner.query(connection,sql,new BeanHandler<>(Image.class),imgID);
            result.setUserName(userDao.findUserByUID(result.getuID()).getUserName());
            result.setCountryName(geoDao.findCountryNameByID(result.getCountry_RegionCodeISO()));
            result.setCityName(geoDao.findCityNameByID(result.getCityCode()));
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null, connection);
        }
        return result;
    }

    public List<Image> returnSearchResult(String str,String select,String sort){
        str = "%"+str+"%";
        String sql = "";
        if(select.equals("title")){
            if(sort.equals("heat"))
                sql = "SELECT * FROM travelimage WHERE Title LIKE ? ORDER BY Heat DESC";
            else if(sort.equals("time"))
                sql = "SELECT * FROM travelimage WHERE Title LIKE ? ORDER BY DateUploaded DESC";
        }else if(select.equals("content")){
            if(sort.equals("heat"))
                sql = "SELECT * FROM travelimage WHERE Content LIKE ? ORDER BY Heat DESC";
            else if(sort.equals("time"))
                sql = "SELECT * FROM travelimage WHERE Content LIKE ? ORDER BY DateUploaded DESC";
        }
        List<Image> result = null;
        try{
            connection = JDBCTools.getConnection();
            result = queryRunner.query(connection,sql,new BeanListHandler<Image>(Image.class),str);
            for(Image image:result){
                image.setUserName(userDao.findUserByUID(image.getuID()).getUserName());
                image.setCountryName(geoDao.findCountryNameByID(image.getCountry_RegionCodeISO()));
                image.setCityName(geoDao.findCityNameByID(image.getCityCode()));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null, connection);
        }
        return result;

    }

    public List<Image> findMyImgByUserName(String userName){
        int uid = userDao.findUserByUserName(userName).getUid();
        String sql = "SELECT * FROM travelimage WHERE UID=?";
        List<Image> result = null;
        try{
            connection = JDBCTools.getConnection();
            result = queryRunner.query(connection,sql,new BeanListHandler<>(Image.class),uid);
            for(Image image:result){
                image.setUserName(userDao.findUserByUID(image.getuID()).getUserName());
                image.setCountryName(geoDao.findCountryNameByID(image.getCountry_RegionCodeISO()));
                image.setCityName(geoDao.findCityNameByID(image.getCityCode()));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null, connection);
        }
        return result;
    }

    public boolean deleteImg(String path){
        String sql = "DELETE FROM travelimage WHERE Path=?";
        boolean result = false;
        try{
            connection = JDBCTools.getConnection();
            int rows = queryRunner.update(connection,sql,path);
            System.out.println(rows);
            if(rows == 1)
                result = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null,connection);
        }
        return result;
    }

    public boolean ifCollect(String path,String userName){
        int uid = userDao.findUserByUserName(userName).getUid();
        int imageID = findImgByPath(path).getImageID();
        String sql = "SELECT * FROM travelimagefavor WHERE UID=? AND ImageID=?";
        boolean result = false;
        try{
            connection = JDBCTools.getConnection();
            if(queryRunner.query(connection,sql,new ArrayListHandler(),uid,imageID).size()==1)
                result = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null,connection);
        }
        return result;
    }

    public boolean unFavor(String path,String userName){
        int uid = userDao.findUserByUserName(userName).getUid();
        int imageID = findImgByPath(path).getImageID();
        String sql = "DELETE FROM travelimagefavor WHERE UID=? AND ImageID=?";
        boolean result = false;
        try{
            connection = JDBCTools.getConnection();
            int rows = queryRunner.update(connection,sql,uid,imageID);
            if(rows == 1)
                result = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null,connection);
        }
        return result;
    }

    public boolean beFavor(String path,String userName){
        int uid = userDao.findUserByUserName(userName).getUid();
        int imageID = findImgByPath(path).getImageID();
        String sql = "INSERT INTO travelimagefavor (UID,ImageID) VALUES (?,?)";
        boolean result = false;
        try{
            connection = JDBCTools.getConnection();
            int rows = queryRunner.update(connection,sql,uid,imageID);
            if(rows == 1)
                result = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null,connection);
        }
        return result;
    }

    public List<Image> findMyFavorByUserName(String userName){
        int uid = userDao.findUserByUserName(userName).getUid();
        String sql = "SELECT * FROM travelimagefavor WHERE UID=?";
        List<Image> result = new LinkedList<>();
        try{
            connection = JDBCTools.getConnection();
            List<Integer> imgIDList = queryRunner.query(connection,sql,new ColumnListHandler<>("ImageID"),uid);
            for(Integer imgId:imgIDList){
                Image image = findImgByID(imgId);
                result.add(image);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null, connection);
        }
        return result;
    }

    public boolean addImage(String title,String content,String description,String country,String city,String userName,String path){
        String sql = "INSERT INTO travelimage (Title,Description,CityCode,Country_RegionCodeISO,UID,Path,Content,Heat,DateUploaded)\n" +
                "VALUES (?,?,?,?,?,?,?,'0',?)";
        boolean result = false;
        try{
            connection = JDBCTools.getConnection();
            Timestamp timestamp = new Timestamp(System.currentTimeMillis());
            int rows = queryRunner.update(connection,sql,title,description,geoDao.findCityIDByName(city),geoDao.findCountryIDByName(country),userDao.findUserByUserName(userName).getUid(),path,content,timestamp);
            if(rows == 1)
                result = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null,connection);
        }
        return result;
    }

    public boolean changeHeat(int change,String path){
        Image image = findImgByPath(path);
        int newHeat = image.getHeat()+change;
        String sql = "UPDATE travelimage SET Heat=? WHERE Path=?";
        boolean result = false;
        try{
            connection = JDBCTools.getConnection();
            int rows = queryRunner.update(connection,sql,newHeat,path);
            if(rows == 1)
                result = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null,connection);
        }
        return result;
    }

    public boolean changeImage(String title,String content,String description,String country,String city,int ImageID){
        String sql = "UPDATE travelimage SET Title=?,Content=?,Description=?,CityCode=?,Country_RegionCodeISO=? WHERE ImageID=?";
        boolean result = false;
        try{
            connection = JDBCTools.getConnection();
            int rows = queryRunner.update(connection,sql,title,content,description,geoDao.findCityIDByName(city),geoDao.findCountryIDByName(country),ImageID);
            if(rows == 1)
                result = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null,connection);
        }
        return result;
    }
}
