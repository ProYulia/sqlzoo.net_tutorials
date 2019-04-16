# SELECT from Nobel Tutorial

Link to the page - https://sqlzoo.net/wiki/SELECT_from_Nobel_Tutorial

## `nobel` table structure

`nobel(yr, subject, winner)`

## 1. Winners from 1950

```sql
SELECT yr, subject, winner
  FROM nobel
 WHERE yr = 1950
```

## 2. 1962 Literature

```sql
SELECT winner
  FROM nobel
 WHERE yr = 1962
   AND subject = 'literature'
```

## 3.

Show the year and subject that won 'Albert Einstein' his prize.

```sql
select yr, subject
from nobel
where winner = 'Albert Einstein'
```

## 4. Recent Peace Prizes

Give the name of the 'Peace' winners since the year 2000, including 2000.

```sql
select winner
from nobel
where subject = 'Peace' and yr >= 2000
order by yr DESC
```

## 5. Literature in the 1980's

Show all details (yr, subject, winner) of the Literature prize winners for 1980 to 1989 inclusive. 

```sql
select * from nobel
where yr > 1979 and yr < 1990
and subject = 'literature'
```

## 6. Only Presidents

Show all details of the presidential winners:

- Theodore Roosevelt
- Woodrow Wilson
- Jimmy Carter
- Barack Obama

```sql
SELECT * FROM nobel
 WHERE winner IN ('Theodore Roosevelt',
                  'Woodrow Wilson',
                  'Jimmy Carter',
'Barack Obama')
```

## 7. John

Show the winners with first name John 

```sql
select winner
from nobel
where winner like 'john%'
```

```sql
select * from nobel
where winner like 'john%'
order by yr
```

## 8. Chemistry and Physics from different years

Show the year, subject, and name of Physics winners for 1980 together with the Chemistry winners for 1984.

```sql
select * from nobel
where (subject = 'physics' and yr = 1980)
  or subject = 'chemistry' and yr = 1984
```

**Results**

|  yr  |  subject  |      winner      |
|------|-----------|------------------|
| 1984 | Chemistry | Bruce Merrifield |
| 1980 | Physics   | James Cronin     |
| 1980 | Physics   | Val Fitch        |

## 9. Exclude Chemists and Medics

Show the year, subject, and name of winners for 1980 excluding Chemistry and Medicine

```sql
select * from nobel
where yr = 1980 and subject NOT IN ('chemistry', 'medicine')
```

**Results**

|  yr  |  subject   |        winner         |
|------|------------|-----------------------|
| 1980 | Economics  | Lawrence R. Klein     |
| 1980 | Literature | Czeslaw Milosz        |
| 1980 | Peace      | Adolfo Pérez Esquivel |
| 1980 | Physics    | James Cronin          |
| 1980 | Physics    | Val Fitch             |

## 10. Early Medicine, Late Literature

Show year, subject, and name of people who won a 'Medicine' prize in an early year (before 1910, not including 1910) together with winners of a 'Literature' prize in a later year (after 2004, including 2004).

```sql
select * from nobel
where yr < 1910 AND subject = 'medicine' OR subject='literature' and yr >= 2004
```

**Results** (partial)

| 2006 | Literature |      Orhan Pamuk       |
|------|------------|------------------------|
| 2005 | Literature | Harold Pinter          |
| 2004 | Literature | Elfriede Jelinek       |
| 1909 | Medicine   | Theodor Kocher         |
| 1908 | Medicine   | Paul Ehrlich           |
| 1908 | Medicine   | Ilya Mechnikov         |
| 1907 | Medicine   | Alphonse Laveran       |
| 1906 | Medicine   | Camillo Golgi          |
| 1906 | Medicine   | Santiago Ramón y Cajal |
| 1905 | Medicine   | Robert Koch            |
| 1904 | Medicine   | Ivan Pavlov            |
| 1903 | Medicine   | Niels Ryberg Finsen    |
| 1902 | Medicine   | Ronald Ross            |
| 1901 | Medicine   | Emil von Behring       |

---

## Harder qustions

---

## 12. Apostrophe

Find all details of the prize won by EUGENE O'NEILL 

```sql
select * from nobel
where winner = 'EUGENE O\'NEILL';

`` or

select * from nobel
where winner = 'EUGENE O''NEILL'
```

|  yr  |  subject   |     winner     |
|------|------------|----------------|
| 1936 | Literature | Eugene O'Neill |

## 13. Knights of the realm

List the winners, year and subject where the winner starts with Sir. Show the the most recent first, then by name order.

```sql
select winner, yr, subject from nobel
where winner LIKE 'Sir%'
ORDER BY yr DESC, winner ASC
```

**Results** (partial)

|       winner        |  yr  |  subject  |
|---------------------|------|-----------|
| Sir Martin J. Evans | 2007 | Medicine  |
| Sir Peter Mansfield | 2003 | Medicine  |
| Sir Paul Nurse      | 2001 | Medicine  |
| Sir Harold Kroto    | 1996 | Chemistry |
| Sir James W. Black  | 1988 | Medicine  |
| Sir Arthur Lewis    | 1979 | Economics |
| Sir Nevill F. Mott  | 1977 | Physics   |
| Sir Bernard Katz    | 1970 | Medicine  |
| Sir John Eccles     | 1963 | Medicine  |

## 14. Chemistry and Physics last

The expression `subject IN ('Chemistry','Physics')` can be used as a value - it will be `0` or `1`.

Show the 1984 winners and subject ordered by subject and winner name; but list Chemistry and Physics last.

```sql
SELECT winner, subject
  FROM nobel
 WHERE yr=1984
 ORDER BY subject IN ('Chemistry ','Physics ') ASC, subject, winner;
```

That was the hard one! Let's try to figure it out.

- ordered by subject and winner name: `ORDER BY subject, winner`
- but list Chemistry and Physics last: `subject IN ('Chemistry ','Physics ') ASC`
- NOTE, `IN` expression at the start of ordering rules
- so first it do sortin between values 0 and 1 in such a way that chemistry and physics goes down
- then it orders subject and winners

**Results**

|       winner        |  subject   |
|---------------------|------------|
| Richard Stone       | Economics  |
| Jaroslav Seifert    | Literature |
| César Milstein      | Medicine   |
| Georges J.F. Köhler | Medicine   |
| Niels K. Jerne      | Medicine   |
| Desmond Tutu        | Peace      |
| Bruce Merrifield    | Chemistry  |
| Carlo Rubbia        | Physics    |
| Simon van der Meer  | Physics    |

