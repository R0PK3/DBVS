CREATE TABLE robu8097.administratorius (

    AK          CHAR(11)        NOT NULL,
    Vardas      VARCHAR(20)     NOT NULL,
    Pavarde     VARCHAR(20)     NOT NULL,
    Atlyginimas DECIMAL(6,2)    NOT NULL CONSTRAINT Alga CHECK (Atlyginimas >= 800 AND Atlyginimas <= 2000),

    PRIMARY KEY (AK)
);

CREATE TABLE robu8097.klientas (

    AK          CHAR(11)        NOT NULL,
    Vardas      VARCHAR(20)     NOT NULL,
    Pavarde     VARCHAR(20)     NOT NULL,
    Telefono_Nr CHAR(15)        NOT NULL,
    El_pastas   VARCHAR(50)     NOT NULL CONSTRAINT NurodytasPastas CHECK (El_pastas LIKE '%___@___%.__%'),

    PRIMARY KEY(AK)
);

CREATE TABLE robu8097.kambarys (

    NR          SERIAL          NOT NULL,
    Tipas       CHAR(9)         NOT NULL CONSTRAINT NurodytasTipas CHECK (Tipas IN ('Paprastas', 'Vidutinis', 'Prabangus')),
    Kaina       DECIMAL(5,2)    NOT NULL CONSTRAINT KambarioKaina CHECK (Kaina >= 25 AND Kaina <= 999),

    PRIMARY KEY (NR)
);

CREATE TABLE robu8097.sutartis (

    ID                  CHAR(5)         NOT NULL,
    Klientas            CHAR(11)        NOT NULL,
    Administratorius    CHAR(11)        NOT NULL,
    Bendra_kaina        DECIMAL(6,2)    NOT NULL,

    PRIMARY KEY (ID),
    FOREIGN KEY (Klientas) REFERENCES robu8097.klientas(AK) ON DELETE CASCADE ON UPDATE RESTRICT,
    FOREIGN KEY (Administratorius) REFERENCES robu8097.administratorius(AK) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE robu8097.itraukia (

    Sutartis            CHAR(5)         NOT NULL,
    Kambarys            SERIAL          NOT NULL,
    Galiojimo_pradzia   DATE            DEFAULT (CURRENT_DATE),
    Galiojimo_pabaiga   DATE            DEFAULT (CURRENT_DATE + INTERVAL '3 day'),

    PRIMARY KEY (Sutartis, Kambarys),
    FOREIGN KEY (Sutartis)  REFERENCES robu8097.sutartis(ID) ON DELETE CASCADE ON UPDATE RESTRICT, 
    FOREIGN KEY (Kambarys)  REFERENCES robu8097.kambarys(NR) ON DELETE RESTRICT ON UPDATE RESTRICT 
);

CREATE UNIQUE INDEX IndexSutarciai
ON robu8097.sutartis(ID);

CREATE INDEX IndexKlientui
ON robu8097.klientas(Vardas, Pavarde);

INSERT INTO robu8097.administratorius VALUES('50210203980','Tomas', 'Giedraitis', 1500);
INSERT INTO robu8097.administratorius VALUES('23648951265','Darius', 'Baranauskas', 1000);
INSERT INTO robu8097.administratorius VALUES('68523789125','Evelina', 'Kučinskytė', 1850);

INSERT INTO robu8097.klientas VALUES('25478965412', 'Giedrius', 'Adomaitis', '37046505391', 'GiedriusAdomaitis@gmail.com');
INSERT INTO robu8097.klientas VALUES('36547895412', 'Aurelija', 'Markevičienė', '37063700561', 'AurMark@one.lt');
INSERT INTO robu8097.klientas VALUES('84562478516', 'Vesta', 'Pociūtė', '37046057613', 'VestaPoc123@inbox.lt');
INSERT INTO robu8097.klientas VALUES('95478123056', 'Kristupas', 'Simonaitis', '37046565625', 'KristupasSimonaitis@hotmail.com');
INSERT INTO robu8097.klientas VALUES('30250014781', 'Rojus', 'Matulaitis', '857939591', 'RojusMatulaitis@gmail.com');

INSERT INTO robu8097.kambarys VALUES(DEFAULT, 'Vidutinis', 150);
INSERT INTO robu8097.kambarys VALUES(DEFAULT, 'Paprastas', 50);
INSERT INTO robu8097.kambarys VALUES(DEFAULT, 'Vidutinis', 100);
INSERT INTO robu8097.kambarys VALUES(DEFAULT, 'Prabangus', 300);
INSERT INTO robu8097.kambarys VALUES(DEFAULT, 'Prabangus', 250);
INSERT INTO robu8097.kambarys VALUES(DEFAULT, 'Vidutinis', 130);
INSERT INTO robu8097.kambarys VALUES(DEFAULT, 'Paprastas', 50);
INSERT INTO robu8097.kambarys VALUES(DEFAULT, 'Vidutinis', 200);

INSERT INTO robu8097.sutartis VALUES('11111', '25478965412', '68523789125', 200);
INSERT INTO robu8097.sutartis VALUES('48641', '84562478516', '23648951265', 130);
INSERT INTO robu8097.sutartis VALUES('97135', '30250014781', '68523789125', 550);
INSERT INTO robu8097.sutartis VALUES('97145', '95478123056', '68523789125', 50);

INSERT INTO robu8097.itraukia VALUES('11111', DEFAULT, '2022-10-19', '2022-10-22');
INSERT INTO robu8097.itraukia VALUES('11111', DEFAULT, '2022-10-23', '2022-10-25');
INSERT INTO robu8097.itraukia VALUES('48641', DEFAULT, '2022-12-10', '2022-12-14');
INSERT INTO robu8097.itraukia VALUES('97135', DEFAULT, '2022-09-01', '2022-09-19');
INSERT INTO robu8097.itraukia VALUES('97135', DEFAULT, '2022-09-01', '2022-09-19');

CREATE VIEW robu8097.viesi_duomenys (Vardas, Pavarde)
AS      SELECT Vardas, Pavarde
        FROM robu8097.administratorius;

CREATE VIEW robu8097.uzimti_kambariai (ID, Kambarys)
AS      SELECT ID, Kambarys
        FROM robu8097.sutartis, robu8097.itraukia
        WHERE robu8097.sutartis.ID = robu8097.itraukia.sutartis;

CREATE MATERIALIZED VIEW robu8097.sudarytos_sutartys(Vardas, Pavarde, ID, Bendra_kaina)
AS      SELECT  Vardas, Pavarde, ID, Bendra_kaina
        FROM    robu8097.klientas, robu8097.sutartis
        WHERE   robu8097.sutartis.klientas = robu8097.klientas.AK;

REFRESH MATERIALIZED VIEW sudarytos_sutartys; 

CREATE FUNCTION KambarioTikrinimas()
RETURNS TRIGGER
AS
'BEGIN
IF( SELECT COUNT(*)
    FROM robu8097.itraukia
    WHERE (robu8097.itraukia.Sutartis = NEW.Sutartis OR robu8097.itraukia.Kambarys = NEW.Kambarys)
    AND    NEW.Galiojimo_pradzia <= robu8097.itraukia.Galiojimo_pabaiga
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


CREATE FUNCTION KambariuKiekis()
RETURNS TRIGGER
AS
'BEGIN
IF(SELECT COUNT(Kambarys)
    FROM robu8097.itraukia, robu8097.sutartis
    WHERE robu8097.itraukia.Sutartis = NEW.Sutartis
    AND robu8097.itraukia.Sutartis = robu8097.sutartis.ID
    ) >= 2
THEN
    RAISE EXCEPTION ''Negalima užsakyti daugiau kambarių!'';
END IF;
RETURN NEW;
END'
LANGUAGE plpgsql;

CREATE TRIGGER KambariuKiekisSutartyje
BEFORE INSERT ON robu8097.itraukia
FOR EACH ROW
EXECUTE PROCEDURE KambariuKiekis();