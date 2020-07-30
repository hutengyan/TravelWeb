package DAO;

import Utils.JDBCTools;
import com.sun.xml.internal.bind.v2.util.CollisionCheckStack;
import javafx.stage.Stage;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.ArrayListHandler;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ColumnListHandler;
import pojo.Image;
import pojo.User;

import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.LinkedList;
import java.util.List;

public class UserDao {

    private QueryRunner queryRunner = new QueryRunner();
    private Connection connection = null;

    public UserDao() {
    }

    public User findUserByUserName(String userName){
        String sql = "SELECT * FROM traveluser WHERE UserName=?";
        User result = null;
        try{
            connection = JDBCTools.getConnection();
            result = queryRunner.query(connection,sql,new BeanHandler<>(User.class),userName);
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null, connection);
        }
        return result;
    }

    public User findUserByUID(int uid){
        String sql = "SELECT * FROM traveluser WHERE UID=?";
        User result = null;
        try{
            connection = JDBCTools.getConnection();
            result = queryRunner.query(connection,sql,new BeanHandler<>(User.class),uid);
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null,connection);
        }
        return result;
    }

    public User findUserByUserNameAndPass(String userName, String pass){
        String sql = "SELECT * FROM traveluser WHERE UserName=? AND Pass=?";
        User result = null;
        try{
            connection = JDBCTools.getConnection();
            result = queryRunner.query(connection,sql,new BeanHandler<User>(User.class),userName,pass);
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null,connection);
        }
        return result;
    }

    public boolean addUser(String userName, String pass, String email){
        String sql = "INSERT INTO traveluser (Email,UserName,Pass,State,DateJoined,DateLastModified)\n" +
                "VALUES (?,?,?,'1',?,?)";
        boolean result = false;
        try{
            connection = JDBCTools.getConnection();
            Timestamp timestamp = new Timestamp(System.currentTimeMillis());
            int rows = queryRunner.update(connection,sql,email,userName,pass,timestamp,timestamp);
            if(rows == 1)
                result = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null,connection);
        }
        return result;
    }

    public boolean changeFavorState(String userName){
        User user = findUserByUserName(userName);
        int newState = 0;
        if(user.getState()==1)
            newState = -1;
        else if(user.getState()==-1)
            newState = 1;
        String sql = "UPDATE traveluser SET State=? WHERE UserName=?";
        boolean result = false;
        try{
            connection = JDBCTools.getConnection();
            int rows = queryRunner.update(connection,sql,newState,userName);
            if(rows == 1)
                result = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null,connection);
        }
        return result;
    }

    public List<User> returnSearchUserResult(String str){
        str = "%"+str+"%";
        String sql = "SELECT * FROM traveluser WHERE UserName LIKE ?";
        List<User> result = null;
        try{
            connection = JDBCTools.getConnection();
            result = queryRunner.query(connection,sql,new BeanListHandler<User>(User.class),str);
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null, connection);
        }
        return result;
    }

    public boolean findInvite(String inviteUserName,int beinviteUID){
        int inviteUID = findUserByUserName(inviteUserName).getUid();
        String sql = "SELECT * FROM travelfriend WHERE inviteUID=? AND beinvitedUID=?";
        boolean result = false;
        try{
            connection = JDBCTools.getConnection();
            if(queryRunner.query(connection,sql,new ArrayListHandler(),inviteUID,beinviteUID).size()==1)
                result = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null,connection);
        }
        return result;
    }

    public boolean addInvite(String inviteUserName,int beinviteUID){
        if(findInvite(inviteUserName,beinviteUID))
            return true;
        else {
            int inviteUID = findUserByUserName(inviteUserName).getUid();
            String sql = "INSERT INTO travelfriend (inviteUID,beinvitedUID,state) VALUES (?,?,0)";
            boolean result = false;
            try{
                connection = JDBCTools.getConnection();

                int rows = queryRunner.update(connection,sql,inviteUID,beinviteUID);
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

    //获取收到的好友申请
    public List<User> findInvitation(String userName){
        int UID = findUserByUserName(userName).getUid();
        String sql = "SELECT * FROM travelfriend WHERE beinvitedUID=? AND state=0";
        List<Integer> uidList = null;
        List<User> result = new LinkedList<>();
        try{
            connection = JDBCTools.getConnection();
            uidList = (List<Integer>) queryRunner.query(connection,sql,new ColumnListHandler("inviteUID"),UID);
            for(int uid:uidList){
                result.add(findUserByUID(uid));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null, connection);
        }
        return result;
    }

    public List<User> findFriend(String userName){
        int UID = findUserByUserName(userName).getUid();
        String sql1 = "SELECT * FROM travelfriend WHERE beinvitedUID=? AND state=1";
        String sql2 = "SELECT * FROM travelfriend WHERE inviteUID=? AND state=1";
        List<User> result = new LinkedList<>();
        try{
            connection = JDBCTools.getConnection();
            List<Integer> uidList1 = (List<Integer>) queryRunner.query(connection,sql1,new ColumnListHandler("inviteUID"),UID);
            for(int uid:uidList1){
                result.add(findUserByUID(uid));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null, connection);
        }

        try{
            connection = JDBCTools.getConnection();
            List<Integer> uidList2 = (List<Integer>) queryRunner.query(connection,sql2,new ColumnListHandler("beinvitedUID"),UID);
            for(int uid:uidList2){
                result.add(findUserByUID(uid));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            JDBCTools.releaseDB(null,null, connection);
        }

        return result;
    }

    public boolean changeInviteState(String ifReceive,String beinviteUserName,int inviteUID){
        int beinvitedUID = findUserByUserName(beinviteUserName).getUid();
        int newState = 0;
        if(ifReceive.equals("true"))
            newState = 1;
        else if(ifReceive.equals("false"))
            newState = -1;
        String sql = "UPDATE travelfriend SET state=? WHERE inviteUID=? AND beinvitedUID=?";
        boolean result = false;
        try{
            connection = JDBCTools.getConnection();
            int rows = queryRunner.update(connection,sql,newState,inviteUID,beinvitedUID);
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
