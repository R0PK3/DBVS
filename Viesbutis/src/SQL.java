import java.sql.*;
import java.util.LinkedList;
import java.util.List;
import java.sql.Driver;

public class SQL
{
    private static Connection postGresConn = null;
    private final String URL = "jdbc:postgresql://pgsql3.mif/studentu";
    private final String Username = "robu8097";
    private final String Password;
    public SQL(String password)
    {
        this.Password = password;
        loadDriver();
        getConnection();
    }
    public static void loadDriver()
    {
        try
        {
            Class.forName("org.postgresql.Driver");
        }
        catch (ClassNotFoundException ex)
        {
            System.out.println("Couldn't find driver class!");
            ex.printStackTrace();
            System.exit(1);
        }
    }
    public Connection getConnection()
    {
        try
        {
            postGresConn = DriverManager.getConnection(URL,Username,Password);
        }
        catch (SQLException ex)
        {
            System.out.println("Couldn't connect to database!");
            ex.printStackTrace();
            return null;
        }
        System.out.println("Successfully connected to Postgres Database!");
        return postGresConn;
    }
    public void closeConnection()
    {
        try
        {
            postGresConn.close();
        }
        catch (SQLException e)
        {
            System.out.println("Error while closing connection to database!");
        }

    }
    public LinkedList<List> queryExecute(String query)
    {
        Statement stmt = null;
        ResultSet rs = null;
        LinkedList<List> result = new LinkedList<>();

        try
        {
            stmt = postGresConn.createStatement();
            rs = stmt.executeQuery(query);

            while(rs.next())
            {
                List<String> row = new LinkedList<String>();

                for(int i = 1; i < rs.getMetaData().getColumnCount() + 1; i++)
                {
                    row.add(rs.getString(i));
                }

                result.add(row);
            }
        }
        catch (SQLException e)
        {
            System.out.println("SQL Error!");
            e.printStackTrace();
        }
        finally
        {
            try
            {
                if(null != rs)
                {
                    rs.close();
                }
                if(null != stmt)
                {
                    stmt.close();
                }
            }
            catch (SQLException ex)
            {
                System.out.println("Unexpected SQL Error!");
                ex.printStackTrace();
            }
        }
        return result;
    }
    public int queryUpdate(String query, boolean transaction)
    {
        Statement stmt = null;
        int success = 0;

        try
        {
            stmt = postGresConn.createStatement();
            success = stmt.executeUpdate(query);
        }
        catch (SQLException e)
        {
            if(transaction)
            {
                queryRollBack();
                manageAutoCommit(true);
            }
            System.out.println("SQL Error!");
            e.printStackTrace();
        }
        finally
        {
            try
            {
                if(null != stmt)
                {
                    stmt.close();
                }
            }
            catch (SQLException ex)
            {
                System.out.println("Unexpected SQL Error");
                ex.printStackTrace();
            }
        }

        return success;
    }
    public void manageAutoCommit(boolean state)
    {
        try
        {
            postGresConn.setAutoCommit(state);
        }
        catch (SQLException ex)
        {
            System.out.println("Unexpected SQL error");
        }
    }
    public void queryCommit()
    {
        try
        {
            postGresConn.commit();
        }
        catch (SQLException ex)
        {
            System.out.println("Unexpected SQL error!");
        }
    }

    public void queryRollBack()
    {
        try
        {
            postGresConn.rollback();
        }
        catch (SQLException ex)
        {
            System.out.println("Unexpected SQL error!");
        }
    }
}
