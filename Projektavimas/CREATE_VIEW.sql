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