# SELECT pattern matching with LIKE

Link to the page on sqlzoo - https://sqlzoo.net/wiki/SELECT_from_WORLD_Tutorial

This tutorial uses the `LIKE` operator to check names. We will be using the `SELECT` command on the table world:

|    name     | continent |
|-------------|-----------|
| Afghanistan | Asia      |
| Albania     | Europe    |
| Algeria     | Africa    |
| Andorra     | Europe    |
| Angola      | Africa    |
| ...         | ...       |

Link to the page - https://sqlzoo.net/wiki/SELECT_names

## 1. Basics

You can use `WHERE name LIKE 'B%'` to find the countries that start with "B".

- The `%` is a *wild-card* it can match any characters

```sql
SELECT name FROM world
  WHERE name LIKE 'Y%'
```

### Results

| name  |
|-------|
| Yemen |

## 2. Basics

Find the countries that start and end with A

```sql
SELECT name FROM world
  WHERE name LIKE '%a' and name LIKE 'a%'
```

### Results

|        name         |
|---------------------|
| Albania             |
| Algeria             |
| Andorra             |
| Angola              |
| Antigua and Barbuda |
| Argentina           |
| Armenia             |
| Australia           |
| Austria             |

## 3. In between

Luxembourg has an x - so does one other country. List them both.

**Find the countries that contain the letter x**

```sql
SELECT name FROM world
WHERE name LIKE '%x%'
```

### Results


|    name    |
|------------|
| Luxembourg |
| Mexico     |

## 4. Ending with word

Iceland, Switzerland end with **land** - but are there others?

**Find the countries that end with land**

```sql
SELECT name FROM world
  WHERE name LIKE '%land'
```

### Results


|    name     |
|-------------|
| Swaziland   |
| Thailand    |
| Finland     |
| Iceland     |
| Ireland     |
| Poland      |
| Switzerland |
| New Zealand |

## 7. Three A

Bahamas has three **a** - who else?

**Find the countries that have three or more a in the name**

```sql
SELECT name FROM world
  WHERE name LIKE '%a%a%a%'
```

### Results

|          name          |
|------------------------|
| Tanzania               |
| Afghanistan            |
| Tobago                 |
| Albania                |
| Bosnia and Herzegovina |
| Panama                 |
| ...                    |

## 8. Single character wildcard

India and Angola have an n as the second character. You can use the **underscore** as a single character wildcard.

**Find the countries that have "t" as the second character.**

```sql
SELECT name FROM world
 WHERE name LIKE '_t%'
ORDER BY name
```

### Results

|   name   |
|----------|
| Ethiopia |
| Italy    |

## 9. More undersocre practice

Lesotho and Moldova both have two o characters separated by two other characters.

**Find the countries that have two "o" characters separated by two others.**

```sql
SELECT name FROM world
 WHERE name LIKE '%o__o%'
```

### Results

|             name              |
|-------------------------------|
| Congo, Democratic Republic of |
| Congo, Republic of            |
| Lesotho                       |
| Morocco                       |
| Sao Tomé and Príncipe         |
| Mongolia                      |
| Moldova                       |

---

## Harder questions

---

## 11.

The capital of **Luxembourg** is **Luxembourg**. Show all the countries where the capital is the same as the name of the country

**Find the country where the name is the capital city.**

```sql
SELECT name
  FROM world
WHERE name LIKE capital
-- can be replaced with
-- name LIKE capital
```

### Results

|    name    |
|------------|
| Djibouti   |
| Luxembourg |
| San Marino |
| Singapore  |

## 12.

The capital of **Mexico** is **Mexico City**. Show all the countries where the capital has the country together with the word "City".

**Find the country where the capital is the country plus "City".**

- The function `concat()` is short for concatenate - you can use it to combine two or more strings.

```sql
SELECT name as country, capital
  FROM world
WHERE capital LIKE concat(name, ' city')
```

### Results

|  country  |    capital     |
|-----------|----------------|
| Guatemala | Guatemala City |
| Kuwait    | Kuwait City    |
| Mexico    | Mexico City    |
| Panama    | Panama City    |

## 13. 

Find the capital and the name where the capital includes the name of the country.

```sql
select capital, name
from world
where capital LIKE concat('%', name, '%')
```

|     capital      |    name    |
|------------------|------------|
| Andorra la Vella | Andorra    |
| Djibouti         | Djibouti   |
| Guatemala City   | Guatemala  |
| Kuwait City      | Kuwait     |
| Luxembourg       | Luxembourg |
| Mexico City      | Mexico     |
| Monaco-Ville     | Monaco     |
| Panama City      | Panama     |
| San Marino       | San Marino |
| Singapore        | Singapore  |

## 14.

**Find the capital and the name where the capital is an extension of name of the country.**

You should include **Mexico City** as it is longer than **Mexico**. You *should not* include **Luxembourg** as the capital is the same as the country.

```sql
select capital, name
from world
where capital LIKE concat(name, '_%')
```

|     capital      |   name    |
|------------------|-----------|
| Andorra la Vella | Andorra   |
| Guatemala City   | Guatemala |
| Kuwait City      | Kuwait    |
| Mexico City      | Mexico    |
| Monaco-Ville     | Monaco    |
| Panama City      | Panama    |

## 15. 

For **Monaco-Ville** the name is **Monaco** and the extension is **-Ville**.

**Show the name and the extension where the capital is an extension of name of the country.**

You can use the SQL function `REPLACE()`

```sql
select name, REPLACE(capital, name, '') as extension
from world
where capital LIKE concat(name, '_%')
```

|   name    | extension |
|-----------|-----------|
| Andorra   | la Vella  |
| Guatemala | City      |
| Kuwait    | City      |
| Mexico    | City      |
| Monaco    | -Ville    |
| Panama    | City      |

### `REPLACE()`

`REPLACE(f, s1, s2)` returns the string f with all occurances of s1 replaced with s2.

```sql
REPLACE('vessel','e','a') -> 'vassal'
```