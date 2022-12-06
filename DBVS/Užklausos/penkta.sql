select table_name, table_schema
from information_schema.columns
group by table_name, table_schema
having count(*) != sum(case
    when columns.is_nullable = 'NO' then 1
    else 0
    end
);