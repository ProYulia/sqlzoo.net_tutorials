# SELECT from WORLD Tutorial

Link to the page on sqlzoo - https://sqlzoo.net/wiki/SELECT_from_WORLD_Tutorial

More about WORLD database is [there](https://sqlzoo.net/wiki/Read_the_notes_about_this_table.) 

`NOTE: some of tasks are skipped.`

## 3. Give the name and the per capita GDP

For those countries with a population of at least 200 million

`NOTE: per capita GDP is the GDP divided by the population GDP/population` 

```sql
select name, (GDP/population) as "per capita GDP"
from world
where population >= 2e8
order by "per capita GDP" DESC;
```

## 8. Exclusive OR (XOR)

Show the countries that are big by area or big by population but not both. Show name, population and area.

```sql
select name, population, area
from world
where population > 25e7 XOR area > 3e6
order by population DESC;
```

## 9. Rounding

For South America show population in millions and GDP in billions both to 2 decimal places.  Use the `ROUND()` function to show the values to two decimal places.

```sql
select name, ROUND(population/1e6,2) as "population", ROUND(gdp/1e9,2) as "GDP"
from world
where continent = 'South America';
```

## 10. Trillion dollar economies

Show per-capita GDP for the trillion dollar countries to the nearest $1000.

`NOTE: ROUND(val, -3) rounds to thousand`

```sql
select name, ROUND(gdp/population, -3) as "per-capita GDP"
from world
where gdp >= 1e12
order by "per-capita GDP" DESC
```

## 11. Name and capital have the same length

Show the name and capital where the name and the capital have the same number of characters.

`NOTE: Use LENGTH(value) to find length of a string`

```sql
SELECT name as country, capital
FROM world
WHERE LENGTH(name) = LENGTH(capital)
```

## 12. Matching name and capital

Show the name and the capital where the first letters of each match. Don't include countries where the name and the capital are the same word.

- You can use the function `LEFT(string, num_of_char)` to isolate the `num_of_char` characters
- You can use `<>` as the `NOT EQUALS` operator

```sql
SELECT name, capital
FROM world
where LEFT(name,1) = LEFT(capital,1) 
AND name <> capital
```

## 13. All the vowels

**Equatorial Guinea** and **Dominican Republic** have all of the vowels (a e i o u) in the name. They don't count because they have more than one word in the name.

**Find the country that has all the vowels and no spaces in its name.**

- You can use the phrase name `NOT LIKE '%a%'` to exclude characters from your results.

```sql
SELECT name
   FROM world
WHERE name NOT LIKE '% %'
  AND name LIKE '%a%'
AND name LIKE '%e%'
AND name LIKE '%i%'
AND name LIKE '%o%'
AND name LIKE '%u%';
```