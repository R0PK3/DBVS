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
