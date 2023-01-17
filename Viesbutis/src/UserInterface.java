import java.io.IOException;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.LinkedList;
import java.util.List;
import java.util.regex.*;
import javax.lang.model.util.ElementScanner6;

public class UserInterface {

    private static boolean runUI = true;

    private final BufferedReader bufferedReader = new BufferedReader (new InputStreamReader(System.in));

    private SQL db;

    public void createUI(String password)
    {
        try
        {
            db = new SQL(password);
            printMenu();
            while(runUI)
            {
                int choice = Integer.parseInt(bufferedReader.readLine());
                switch (choice)
                {
                    case 0:
                        runUI = false;
                        System.out.println("Sekmingai isejote is programos!");
                        db.closeConnection();
                        break;
                    case 1:
                        findCustomerContracts();
                        break;
                    case 2:
                        registerNewCustomer();
                        break;
                    case 3:
                        dismissAdministrator();
                        break;
                    case 4:
                        changeAdministratorSalary();
                        break;
                    case 5:
                        cancelContract();
                        break;
                    case 6:
                        displayAllContracts();
                        break;
                    default:
                        System.out.println("Blogas pasirinkimas!");
                        break;
                    
                }
            }
        }
        catch(IOException e)
        {
            System.out.println("Klaida skaitant ivesti!");
        }
        catch(NumberFormatException e)
        {
            System.out.println("Netinkamas ivesties formatas!");
        }
    }

    public static void printMenu()
    {
        System.out.println("Meniu:\n" +
                "[0] - Uzbaigti darba\n" +
                "[1] - Rasti kliento sutartis\n" +
                "[2] - Uzregistruoti nauja klienta\n" +
                "[3] - Atleisti administratoriu\n" +
                "[4] - Pakeisti administratoriaus alga\n" +
                "[5] - Nutraukti sutarti\n" +
                "[6] - Parodyti visas sutartis\n");
    }

    public void findCustomerContracts()
    {
        LinkedList<List> result;
        try
        {
            result = db.queryExecute("SELECT AK, Vardas, Pavarde FROM robu8097.klientas");

            displayAllCustomers();

            System.out.println("\nIveskite kliento asmens koda:");
            String ak = bufferedReader.readLine();

            if(isValidId(ak))
            {
                result = db.queryExecute("SELECT ID, Klientas, Administratorius, Bendra_kaina FROM robu8097.klientas, robu8097.sutartis" +
                "WHERE klientas.AK = sutartis.Klientas AND klientas.AK = '" + ak + "'");
                if(result.size() == 0)
                {
                    System.out.println("Klientas sutarciu neturi!");
                }
                else
                {
                    System.out.println("Kliento sutartys:\n");
                    System.out.printf("%s %4s %14s %9s %13s %9s %14s\n\n", "ID", "|", "Kliento AK", "|", "Administratoriaus AK", "|", "Bendra kaina");
                    for(List list : result)
                    {
                        System.out.printf("%s %20s %25s %25s\n", list.get(0), list.get(1), list.get(2), list.get(3));
                    }
                }
                
            }
            else
            {
                System.out.println("Netinkamas asmens kodas!");
            }
        }
        catch(Exception ex)
        {
            System.out.println("Ivyko klaida: " + ex.getMessage());
        }
    }

    public void registerNewCustomer()
    {
        System.out.println("Iveskite naujo kliento asmens koda, varda, pavarde, el. pasta, tel. nr: \n");
        try
        {
            int success = 0;

            System.out.println("Asmens kodas: ");
            String ak = bufferedReader.readLine();

            System.out.println("Vardas: ");
            String vardas = bufferedReader.readLine();

            System.out.println("Pavarde: ");
            String pavarde = bufferedReader.readLine();

            System.out.println("El. pastas: ");
            String el_pastas = bufferedReader.readLine();

            System.out.println("Telefono nr: ");
            String tel_nr = bufferedReader.readLine();

            if(isValidId(ak) && isValidNameSurname(vardas) && isValidNameSurname(pavarde) && (tel_nr.length() == 11 || tel_nr.length() == 9))
            {
                success = db.queryUpdate("INSERT INTO robu8097.klientas VALUES('"+ ak + "', '" + vardas +"', '" + pavarde + "', '" + el_pastas + "', '" + tel_nr + "')", false);
                if(success == 0)
                {
                    System.out.println("Kliento registravimas nesekmingas!");
                }
                else
                {
                    System.out.println("Sekmingai uzregistravote klienta!");
                }
            }
            else
            {
                System.out.println("Netinkama duomenu ivestis!");
            }

        }
        catch(Exception ex)
        {
            System.out.println("Klaida registruojant klienta!");
            ex.printStackTrace();
        }
        

    }
//
    public void dismissAdministrator()
    {
        try
        {
            LinkedList<List> result;
            int success = 0;
            displayAllAdministrators();

            System.out.println("Iveskite administratoriaus asmens koda:\n ");
            System.out.println("Asmens kodas: ");
            String ak1 = bufferedReader.readLine();

            if(isValidId(ak1))
            {
                result = db.queryExecute("SELECT COUNT(*) FROM robu8097.sutartis WHERE Administratorius = '" + ak1 + "'");

                if(!result.getFirst().get(0).equals(0))
                {   
                    System.out.println("Negalite atleisti administratoriaus, kuris dalyvauja aktyvioje(se) sutartyje(se)!");
                    result = db.queryExecute("select distinct administratorius.ak, vardas, pavarde, Atlyginimas from robu8097.administratorius, robu8097.sutartis" + 
                    "where ak = (select ak from robu8097.administratorius where ak = '" + ak1 + "') AND AK NOT IN (robu8097.sutartis.administratorius)");

                    System.out.println("Tinkami administatoriai: ");
                    for(List list : result)
                    {
                        System.out.printf("\n%s %10s %10s %5s %10s %5s %10s\n\n", "AK", "|", "Vardas","|", "Pavarde", "|", "Atlyginimas");
                        System.out.printf("%s %14s %19s %15s \n", list.get(0), list.get(1), list.get(2), list.get(3));
                    }

                    System.out.println("\nIveskite administratoriaus, kuriam perleisite sutartis, asmens koda: \n");
                    String ak2= bufferedReader.readLine();

                    if(isValidId(ak2))
                    {
                        result = db.queryExecute("SELECT ID FROM robu8097.sutartis WHERE Administratorius = '" + ak1 + "'");

                        db.manageAutoCommit(false);

                        for(List list: result)
                        {
                            db.queryUpdate("UPDATE robu8097.sutartis SET Administratorius = '" + ak2 + "' WHERE ID = " + list.get(0), true);
                        }

                        success = db.queryUpdate("DELETE FROM robu8097.administratorius WHERE AK = '" + ak1 + "'", true);
                        if(success != 0)
                        {
                            db.queryCommit();
                            db.manageAutoCommit(true);
                            System.out.println("Sekmingai atleidote administratoriu!");
                        }
                        else
                        {
                            db.queryRollBack();
                            db.manageAutoCommit(true);
                            System.out.println("Nepavyko atleisti administratoriaus!");
                        }
                    }
                    else
                    {
                        System.out.println("Netinkama duomenu ivestis");
                    }

                }
                else
                {
                   int success2= 0;
                   
                   success2 = db.queryUpdate("DELETE FROM robu8097.administratorius WHERE AK = '" + ak1 + "'",false);

                   if(success2 == 1)
                   {
                    System.out.println("Sekmingai atleidote administratoriu!");
                   }
                   else
                   {
                    System.out.println("Toks administratorius neegzistuoja!");
                   }
                }
            }
            else
            {
                System.out.println("Netinkama duomenu ivestis!");
            }
        }
        catch(Exception ex)
        {
            System.out.println("Klaida atleidziant administratoriu!");
            ex.printStackTrace();
        }
    }
//
    public void changeAdministratorSalary()
    {
        try
        {
            int success = 0;
            displayAllAdministrators();

            System.out.println("Iveskite administratoriaus asmens koda ir nauja alga:\n");
            System.out.println("Asmens kodas: ");
            String ak = bufferedReader.readLine();

            System.out.println("Alga: ");
            String alga = bufferedReader.readLine();
            int algaParsed = Integer.parseInt(alga);

            if(isValidId(ak))
            {
                success = db.queryUpdate("UPDATE robu8097.administratorius SET Atlyginimas = " + algaParsed + "WHERE AK = '" + ak + "'", false);
                if(success == 0 || algaParsed < 800 || algaParsed > 2000)
                {
                    System.out.println("Algos atnaujinimas nesekmingas.");
                }
                else
                {
                    System.out.println("Sekmingai atnaujinote administratoriaus alga!");
                }
            }
            else
            {
                System.out.println("Netinkama duomenu ivestis!");
            }
        }
        catch(Exception ex)
        {
            System.out.println("Klaida keiciant administratoriaus alga!");
            ex.printStackTrace();
        }
    }

    public void cancelContract()
    {
        LinkedList<List> result;
        try
        {
            int successC = 0;
            int successI = 0;

            displayAllContracts();

            System.out.println("Nurodykite sutarties ID, kuri norite pasalinti: ");
            String id = bufferedReader.readLine();
            int idparsed = Integer.parseInt(id);

            successC = db.queryUpdate("DELETE FROM robu8097.sutartis WHERE ID = " + idparsed, false);
            successI = db.queryUpdate("DELETE FROM robu8097.itraukia WHERE Sutartis = " + idparsed, false);

            if(successC == 0)
            {
                System.out.println("Tokios sutarties nera! Sutarties istrinymas nesekmingas.");
            }
            else
            {
                System.out.println("Sekmingai istrynete sutarti!");
            }
        }
        catch(Exception ex)
        {
            System.out.println("Klaida atsaukiant apsilankyma!");
            ex.printStackTrace();
        }
    }

    //--------------------------------------------------------------------------------------------------------------------------\\

    private void displayAllContracts()
    {
        LinkedList<List> result;

        result = db.queryExecute("SELECT * FROM robu8097.sutartis");
        System.out.println("Visos sutartys:\n");
        System.out.printf("%s %s %5s %5s %5s %5s %7s\n\n", "ID", "|", "Kliento AK","|", "Administratoriaus AK","|", "Bendra kaina");
        for (List list : result) {
            System.out.printf("%s %14s %17s %15s \n", list.get(0), list.get(1), list.get(2), list.get(3));
        }
    }

    private void displayAllAdministrators()
    {
        LinkedList<List> result;

        result = db.queryExecute("SELECT * FROM robu8097.administratorius");
        System.out.println("Visi administratoriai:\n");
        System.out.printf("%s %10s %10s %5s %10s %5s %10s \n\n", "AK", "|", "Vardas","|", "Pavarde","|", "Atlyginimas");
        for (List list : result) {
            System.out.printf("%s %14s %17s %18s\n", list.get(0), list.get(1), list.get(2), list.get(3));
        }
    }

    private void displayAllCustomers()
    {
        LinkedList<List> result;

        result = db.queryExecute("SELECT Ak, Vardas, Pavarde FROM robu8097.klientas");
        System.out.println("Klientai:");
        System.out.printf("%s %9s %15s %9s %10s\n\n", "AK", "|", "Vardas","|", "Pavarde");
        for (List list : result) {
            System.out.printf("%11s %15s %22s\n", list.get(0), list.get(1), list.get(2));
        }
    }

    public boolean isValidNameSurname(String s){
        String regex = "^[A-Za-z]\\w{0,29}$";

        Pattern p = Pattern.compile(regex);

        if (s == null) {
            return false;
        }
        Matcher m = p.matcher(s);

        return m.matches();
    }

    public boolean isValidId(String ak){
        String regex = "^[0-9]*$";

        Pattern p = Pattern.compile(regex);
        if(ak == null){
            return false;
        }
        Matcher m = p.matcher(ak);

        return m.matches() && ak.length() == 11;
    }

}
