# More JOIN operations

Link to the page - https://sqlzoo.net/w/index.php/More_JOIN_operations

This tutorial introduces the notion of a join. The database consists of three tables `movie` , `actor` and `casting` .

## Movie Database

This database features two entities (movies and actors) in a many-to-many relation. Each entity has its own table. A third table, casting , is used to link them. The relationship is many-to-many because each film features many actors and each actor has appeared in many films.

movie

| id  | title  | yr  | director  | budget  | gross |

actor

| id  | name |

casting

| movieid  | actorid  | ord |

![Movies database schema](movie-er.png)

[More info about tables](https://sqlzoo.net/wiki/More_details_about_the_database.)

## 1. 1962 movies

List the films where the yr is 1962 [Show id, title].

```sql
SELECT id, title
 FROM movie
 WHERE yr=1962
```

|  id   |                title                |
|-------|-------------------------------------|
| 10212 | A Kind of Loving                    |
| 10329 | A Symposium on Popular Songs        |
| 10347 | A Very Private Affair (Vie PrivÃ©e) |
| 10648 | An Autumn Afternoon                 |
|   ... |                                     |

## 2. When was Citizen Kane released?

Give year of 'Citizen Kane'.

```sql
select yr from movie
where title = 'citizen kane'
```

|  yr  |
|------|
| 1941 |

## 3. Star Trek movies

List all of the Star Trek movies, include the `id`, `title` and `yr` (all of these movies include the words Star Trek in the title). Order results by year.

```sql
select id,title,yr from movie
  where title like '%star trek%'
  order by yr
```

|  id   |                title                |  yr  |
|-------|-------------------------------------|------|
| 17772 | Star Trek: The Motion Picture       | 1979 |
| 17775 | Star Trek II: The Wrath of Khan     | 1982 |
| 17776 | Star Trek III: The Search for Spock | 1984 |
| 17777 | Star Trek IV: The Voyage Home       | 1986 |
| 17779 | Star Trek V: The Final Frontier     | 1989 |
|   ... |                                     |      |

[Getting to the point](https://sqlzoo.net/wiki/Get_to_the_point)

## 6. Cast list for Casablanca

Obtain the cast list for 'Casablanca'. The cast list is the names of the actors who were in the movie.

```sql
select a.name 
  from casting c join actor a ON c.actorid=a.id
  where movieid=11768
```

|       name       |
|------------------|
| Peter Lorre      |
| John Qualen      |
| Madeleine LeBeau |
| Jack Benny       |
| Dan Seymour      |
| Norma Varden     |
| Ingrid Bergman   |
| Conrad Veidt     |
| Leon Belasco     |
| ...              |

## 7. Alien cast list

Obtain the cast list for the film 'Alien'

```sql
select name
  from casting
    join actor ON actorid=id
  where movieid = (select id from movie where title='Alien')
  order by ord
```

|        name         |
|---------------------|
| Tom Skerritt        |
| Sigourney Weaver    |
| Veronica Cartwright |
| Harry Dean Stanton  |
| John Hurt           |
| Ian Holm            |
| Yaphet Kotto        |

## 8. Harrison Ford movies

List the films in which 'Harrison Ford' has appeared

```sql
select title
  from movie m
    join casting c ON id=movieid
    join actor a ON a.id=c.actorid
  where a.name = 'Harrison Ford'
```

|          title           |
|--------------------------|
| A Hundred and One Nights |
| Air Force One            |
| American Graffiti        |
| Apocalypse Now           |
| Clear and Present Danger |
| Cowboys & Aliens         |
| ...                      |

## 9. Harrison Ford as a supporting actor

List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]

```sql
select title
  from movie m
    join casting c ON id=movieid
    join actor a ON a.id=c.actorid
  where a.name = 'Harrison Ford' AND c.ord > 1
```

|          title           |
|--------------------------|
| A Hundred and One Nights |
| American Graffiti        |
| Apocalypse Now           |
| Cowboys & Aliens         |
| ...                      |

## 10. Lead actors in 1962 movies

List the films together with the leading star for all 1962 films.

```sql
select title, name
  from movie m
    join casting c on m.id=movieid
    join actor a on a.id=actorid
  where yr=1962 and ord=1
```

|                    title                    |            name            |
|---------------------------------------------|----------------------------|
| A Kind of Loving                            | Alan Bates                 |
| A Symposium on Popular Songs                | Paul Frees                 |
| A Very Private Affair (Vie PrivÃ©e)         | Brigitte Bardot            |
| An Autumn Afternoon                         | Chishu Ryu                 |
| Atraco a las tres                           | JosÃ© Luis LÃ³pez VÃ¡zquez |
| Barabbas                                    | Anthony Quinn              |
| Battle Beyond the Sun (ÐÐµÐ±Ð¾ Ð·Ð¾Ð²ÐµÑ‚)  | Aleksandr Shvorin          |
| ...                                         |                            |

-------------

## Harder Questions

-------------

## 11. Busy years for John Travolta

Which were the busiest years for 'John Travolta', show the year and the number of movies he made each year for any year in which he made more than 2 movies.

```sql
SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
        JOIN actor   ON actorid=actor.id
where name='John Travolta'
GROUP BY yr
HAVING COUNT(title)=(SELECT MAX(c) FROM
(SELECT yr,COUNT(title) AS c FROM
   movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
 where name='John Travolta'
 GROUP BY yr) AS t
)
```

|  yr  | COUNT(title) |
|------|--------------|
| 1998 |            3 |

- NOTE this complex query was already written for us

## 12. Lead actor in Julie Andrews movies

```sql
select title, a.name
  from movie m
    join casting c ON movieid=m.id
    join actor a ON a.id=c.actorid
  where ord=1
    AND movieid
    IN (SELECT movieid FROM casting
        WHERE actorid IN (
          SELECT id FROM actor
              WHERE name='Julie Andrews')
              );

-- the same result can be achived with JOIN

select DISTINCT title, a.name
  from movie m
    join casting c ON movieid=m.id
    join actor a ON a.id=c.actorid
    join (SELECT movieid FROM casting
        WHERE actorid IN (
          SELECT id FROM actor
              WHERE name='Julie Andrews')
              ) AS tmp ON tmp.movieid = m.id
  where ord=1;
```

|       title        |      name      |
|--------------------|----------------|
| 10                 | Dudley Moore   |
| Darling Lili       | Julie Andrews  |
| Despicable Me      | Steve Carell   |
| Duet for One       | Julie Andrews  |
| Hawaii             | Julie Andrews  |
| Little Miss Marker | Walter Matthau |
| ...                |                |

## 13. Actors with 30 leading roles

Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.

```sql
select a.name
  from actor a
    join casting ON (actorid=id AND ord=1)
  GROUP BY a.name
  HAVING COUNT(*) >=30
ORDER BY a.name ASC
```

|      name       |
|-----------------|
| Bette Davis     |
| Bruce Willis    |
| Burt Lancaster  |
| Gary Cooper     |
| James Stewart   |
| John Wayne      |
| Paul Newman     |
| Spencer Tracy   |
| William Garwood |

## 14.

List the films released in the year 1978 ordered by the number of actors in the cast, then by title.

```sql
select title, count(actorid)
  from movie m
    join casting on (movieid=m.id AND yr=1978)
  group by title
order by 2 DESC, title
```

|             title              | count(actorid) |
|--------------------------------|----------------|
| The Bad News Bears Go to Japan |             50 |
| The Swarm                      |             37 |
| Grease                         |             28 |
| American Hot Wax               |             27 |
| The Boys from Brazil           |             26 |
| Heaven Can Wait                |             25 |
| ...                            |                |

- NOTE The problem text is unclear in which order (ascending or descending) for which coulumn should be used.

## 15.

List all the people who have worked with 'Art Garfunkel'.

```sql
-- Art Garfunkel id is 1112
-- 1112 should be replaced with a query
-- select id from actor where name = 'Art Garfunkel'

select DISTINCT a.name
  from movie m
    join casting c ON (movieid=m.id AND actorid NOT IN (1112))
    join actor a ON (a.id=actorid)
  where
    m.id in
        (select movie.id
        from movie join casting c ON (movieid=id AND actorid NOT IN (1112)))
```

|        name        |
|--------------------|
| Mark Ruffalo       |
| Ryan Phillippe     |
| Mike Myers         |
| Neve Campbell      |
| Salma Hayek        |
| Sela Ward          |
| Breckin Meyer      |
| Sherry Stringfield |
| ...                |

What was really needeed:

- Any actors from movies where director is 1112
- And any directors if an actor is 1112
- And any actors from movies where 1112 is acting excluding 1112
