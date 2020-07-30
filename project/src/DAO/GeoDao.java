package DAO;

import Utils.JDBCTools;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.ColumnListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;
import pojo.User;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

public class GeoDao {
    private QueryRunner queryRunner = new QueryRunner();
    private Connection connection = null;

    public GeoDao() {
    }

    public List<String> findAllCountry(){
        String countrySql = "SELECT * FROM geocountries_regions";
        List<String> countrylist = new LinkedList<>();
        try{
            connection = JDBCTools.getConnection();
            countrylist = (List<String>) queryRunner.query(connection,countrySql,new ColumnListHandler("Country_RegionName"));

        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null,connection);
        }
        return countrylist;
    }

    public List<String> findCity(String countryName){
        String countryISO = findCountryIDByName(countryName);
        String citySQL = "SELECT * FROM geocities WHERE Country_RegionCodeISO=?";
        List<String> list = new LinkedList<>();
        try{
            connection = JDBCTools.getConnection();
            list = (List<String>) queryRunner.query(connection,citySQL,new ColumnListHandler("AsciiName"),countryISO);
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null,connection);
        }
        return list;
    }

    public String findCountryIDByName(String name){
        String sql = "SELECT * FROM geocountries_regions WHERE Country_RegionName=?";
        String result = "";
        try{
            connection = JDBCTools.getConnection();
            result = queryRunner.query(connection,sql,new ScalarHandler<String>("ISO"),name);
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null,connection);
        }
        return result;
    }

    public String findCountryNameByID(String ISO){
        String sql = "SELECT * FROM geocountries_regions WHERE ISO=?";
        String result = "";
        try{
            connection = JDBCTools.getConnection();
            result = queryRunner.query(connection,sql,new ScalarHandler<String>("Country_RegionName"),ISO);
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null,connection);
        }
        return result;

    }

    public int findCityIDByName(String name){
        String sql = "SELECT * FROM geocities WHERE AsciiName=?";
        int result = 0;
        try{
            connection = JDBCTools.getConnection();
            result = queryRunner.query(connection,sql,new ScalarHandler<>("GeoNameID"),name);
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null,connection);
        }
        return result;
    }

    public String findCityNameByID(int CityID){
        String sql = "SELECT * FROM geocities WHERE GeoNameID=?";
        String result = "";
        try{
            connection = JDBCTools.getConnection();
            result = queryRunner.query(connection,sql,new ScalarHandler<String>("AsciiName"),CityID);
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null,connection);
        }
        return result;

    }
}
