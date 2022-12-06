select egzempliorius.nr, egzempliorius.paimta, egzempliorius.grazinti, skaitytojas.vardas, skaitytojas.pavarde,
(current_date - egzempliorius.paimta) as "Praejo laiko"
from stud.egzempliorius, stud.skaitytojas
where egzempliorius.skaitytojas = skaitytojas.nr
order by "Praejo laiko";