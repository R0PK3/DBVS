CREATE FUNCTION KambarioTikrinimas()
RETURNS TRIGGER
AS
'BEGIN
IF( SELECT COUNT(*)
    FROM robu8097.itraukia
    WHERE (robu8097.itraukia.Sutartis = NEW.Sutartis OR robu8097.itraukia.Kambarys = NEW.Kambarys)
    AND    NEW.Galiojimo_pradzia > robu8097.itraukia.Galiojimo_pabaiga
    AND   robu8097.itraukia.Galiojimo_pabaiga = NEW.Galiojimo_pabaiga) > 0
THEN
    RAISE EXCEPTION ''Kambarys užimtas!'';
END IF;
RETURN NEW;
END;'
LANGUAGE plpgsql;

CREATE TRIGGER NeužimtoKambarioTikrinimas
BEFORE INSERT OR UPDATE ON robu8097.itraukia
FOR EACH ROW
EXECUTE PROCEDURE KambarioTikrinimas();

CREATE FUNCTION Tikrinimas()
RETURNS TRIGGER
AS

LANGUAGE plpgsql;

CREATE TRIGGER Tikrininimas
BEFORE INSERT OR UPDATE ON robu8097.