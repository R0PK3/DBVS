select count(grazinti) as "Egzemplioriai", count(distinct egzempliorius.isbn) as "Knygos", count('isbn'), count(*)
from stud.egzempliorius, stud.knyga
where egzempliorius.grazinti <= date('2022-10-12') and stud.egzempliorius.isbn = stud.knyga.isbn;