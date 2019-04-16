select 
  m.module_title as Module,
  s.first_name || ' ' || s.last_name as Student,
  r.result as Scores
   from registration r
    join module m on (m.module_code = r.module_code)
    join student s on (s.matric_no = r.matric_no)
   where r.result IS NOT NULL
;

-- how many modules regsitered by each student
-- and what is total score of each student
select 
  s.first_name || ' ' || s.last_name as Student,
  COUNT(r.module_code) as "Modules taken",
  SUM(r.result) as "Total scores"
   from registration r
    join module m on (m.module_code = r.module_code)
    join student s on (s.matric_no = r.matric_no)
   where r.result IS NOT NULL
   group by Student
  order by 2 DESC, 1, 3 DESC
;

-- show the student and the best module
-- where the student has max result
select
  s.first_name || ' ' || s.last_name as Student,
  m.module_title "Best result module",
  MAX(r.result) as "Result"
  from registration r
    join module m on (m.module_code = r.module_code)
    join student s on (s.matric_no = r.matric_no)
   where r.result IS NOT NULL
   group by Student
;
