DROP TRIGGER NeužimtoKambarioTikrinimas ON robu8097.itraukia;
DROP TRIGGER KambariuKiekisSutartyje ON robu8097.itraukia;
DROP FUNCTION robu8097.KambarioTikrinimas();
DROP FUNCTION robu8097.KambariuKiekis();

DROP VIEW robu8097.viesi_duomenys;
DROP VIEW robu8097.uzimti_kambariai;
DROP MATERIALIZED VIEW robu8097.sudarytos_sutartys;

DROP INDEX IndexSutarciai;
DROP INDEX IndexKlientui;

DROP TABLE robu8097.administratorius;
DROP TABLE robu8097.itraukia;
DROP TABLE robu8097.klientas;
DROP TABLE robu8097.sutartis;
DROP TABLE robu8097.kambarys;