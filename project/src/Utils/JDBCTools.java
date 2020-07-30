package Utils;

import com.mchange.v2.c3p0.ComboPooledDataSource;

import java.sql.*;

public class JDBCTools {

    //释放数据库资源
    public static void releaseDB(ResultSet resultSet, Statement statement,Connection connection){
        if(resultSet != null){
            try{
                resultSet.close();
            }catch (SQLException e){
                e.printStackTrace();
            }
        }
        if(statement != null){
            try {
                statement.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if(connection != null){
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    //获取数据库连接

    private static ComboPooledDataSource dataSource ;
    static {
        dataSource = new ComboPooledDataSource("helloc3p0");
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

}
