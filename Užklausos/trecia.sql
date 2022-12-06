select substring(egzempliorius.isbn,1,4) as ketvertas, count(egzempliorius.nr) as egzemplioriu_skaicius, count(distinct knyga.nr) as knygu_skaicius,
count(distinct knyga.leidykla) as leidyklu_skaicius
from stud.egzempliorius, stud.knyga
where egzempliorius.isbn = knyga.isbn
group by ketvertas
having count(egzempliorius.isbn) > 10;