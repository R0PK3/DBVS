with lentele as(
    select pavadinimas, count(egzempliorius.isbn) * coalesce(verte, 15) as bendra_verte
    from stud.egzempliorius, stud.knyga
    where egzempliorius.isbn = knyga.isbn
    group by pavadinimas, knyga.verte
),
lentele2 as(
    select round(avg(bendra_verte), 2) as average
    from lentele
)
select lentele.pavadinimas, bendra_verte, average
from lentele, lentele2
where bendra_verte < average;