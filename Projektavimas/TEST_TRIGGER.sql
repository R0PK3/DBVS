INSERT INTO robu8097.itraukia VALUES('97145', DEFAULT, '2022-12-13', '2022-12-16'); -- OK
INSERT INTO robu8097.itraukia VALUES('97145', 6, '2022-12-14', '2022-12-16'); --FAILED

UPDATE robu8097.itraukia SET Galiojimo_pradzia = '2022-10-22', Galiojimo_pabaiga = '2022-10-24' WHERE Sutartis = '97135' AND Kambarys = 5; --OK
UPDATE robu8097.itraukia SET Kambarys = '7', Galiojimo_pabaiga = '2023-11-11', Galiojimo_pabaiga = '2023-11-15' WHERE Sutartis = '11111';

INSERT INTO robu8097.itraukia VALUES('11111', DEFAULT, '2022-12-10', '2022-12-14'); --FAILED (per daug kambariu)
INSERT INTO robu8097.itraukia VALUES('97145', DEFAULT, '2023-01-01', '2023-01-03'); --OK
