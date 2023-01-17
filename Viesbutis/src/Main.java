import java.io.*;

public class Main
{
    public static void main(String[] args)
    {
        Console cnsl = System.console();
        char[] ch = cnsl.readPassword("Enter password : ");
        String password = new String(ch);
        UserInterface ui = new UserInterface();
        ui.createUI(password);
    }
}
