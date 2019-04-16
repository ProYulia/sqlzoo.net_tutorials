# Self JOIN

Link to the page - https://sqlzoo.net/wiki/Self_join

## Edinburgh Buses

[Details of the database](https://sqlzoo.net/wiki/Edinburgh_Buses.) Looking at the data

    stops(id, name)
    route(num, company, pos, stop)

### stops

This is a list of areas served by buses. The detail does not really include each actual bus stop - just areas within Edinburgh and whole towns near Edinburgh.

| Field |   Type   |                     Notes                      |
|-------|----------|------------------------------------------------|
| id    | INTEGER  | Arbitrary value                                |
| name  | CHAR(30) | The name of an area served by at least one bus |

### route

A route is the path through town taken by a bus.

|  Field  |  Type   |                               Notes                                |
|---------|---------|--------------------------------------------------------------------|
| num     | CHAR(5) | The number of the bus - as it appears on the front of the vehicle. |
|         |         | Oddly these numbers often include letters                          |
| company | CHAR(3) | Several bus companies operate in Edinburgh.                        |
|         |         | The main one is Lothian Region Transport - LRT                     |
| pos     | INTEGER | This indicates the order of the stop within the route.             |
|         |         | Some routes may revisit a stop. Most buses go in both directions.  |
| stop    | INTEGER | This references the stops table                                    |

As different companies use numbers arbitrarily the num and the company are both required to identify a route.

## 4. Routes and stops

The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.

```sql
SELECT company, num, COUNT(*) numstops
    FROM route WHERE stop=149 OR stop=53
    GROUP BY company, num
    HAVING numstops = 2
```

| company | num | numstops |
|---------|-----|----------|
| LRT     |   4 |        2 |
| LRT     |  45 |        2 |

## 5.

Execute the self join

```sql
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53

-- Query below show stops' names instead of stops' ids
SELECT a.company, a.num, s.name, s2.name
FROM route a
  JOIN route b ON (a.company=b.company AND a.num=b.num)
  JOIN stops s ON (s.id=a.stop)
  JOIN stops s2 ON (s2.id=b.stop)
WHERE a.stop=53
```

and observe that `b.stop` gives all the places you can get to from **Craiglockhart**, without changing routes. Change the query so that it shows the services from **Craiglockhart** to **London Road**.

```sql
SELECT a.company, a.num, a.stop, b.stop
FROM route a 
  JOIN route b ON (a.company=b.company AND a.num=b.num)
  JOIN stops s2 ON (s2.id=b.stop)
WHERE a.stop=53 and s2.name='London Road'
```

| company | num | stop | stop |
|---------|-----|------|------|
| LRT     |   4 |   53 |  149 |
| LRT     |  45 |   53 |  149 |

## 6.

The query

```sql
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart'
```

is similar to the previous one, however by joining two copies of the stops table we can refer to **stops** by **name** rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross'.

```sql
SELECT a.company, a.num "bus num", stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' and stopb.name='London Road'
```

| company | bus num |     name      |    name     |
|---------|---------|---------------|-------------|
| LRT     |       4 | Craiglockhart | London Road |
| LRT     |      45 | Craiglockhart | London Road |

## 7. [Using a self join](https://sqlzoo.net/wiki/Using_a_self_join)

```sql
SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=115 AND b.stop=137
```

| LRT | 12 |
|-----|----|
| LRT | 2  |
| LRT | 22 |
| LRT | 25 |
| LRT | 2A |
| SMT | C5 |

## 8.

Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'

```sql
SELECT a.company, a.num "bus num"
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id AND stopa.name='Craiglockhart')
  JOIN stops stopb ON (b.stop=stopb.id AND stopb.name='Tollcross')
```

| company | bus num |
|---------|---------|
| LRT     |      10 |
| LRT     |      27 |
| LRT     |      45 |
| LRT     |      47 |

- NOTE looks like "correct" query produces incorrect answer

## 9.

Give a distinct list of the **stops** which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.

```sql
SELECT DISTINCT s2.name, a.company, a.num FROM route a 
  JOIN route b ON (a.company=b.company AND a.num=b.num AND a.company='LRT')
  JOIN stops s1 on (s1.id=a.stop AND s1.name='Craiglockhart')
  JOIN stops s2 on (s2.id=b.stop)
```

|       name        | company | num |
|-------------------|---------|-----|
| Silverknowes      | LRT     |  10 |
| Muirhouse         | LRT     |  10 |
| Newhaven          | LRT     |  10 |
| Leith             | LRT     |  10 |
| ...               |         |     |
| Crewe Toll        | LRT     |  27 |
| Canonmills        | LRT     |  27 |
| Hanover Street    | LRT     |  27 |
| Tollcross         | LRT     |  27 |
| ...               | LRT     |  27 |

## 10.

Find the routes involving two buses that can go from **Craiglockhart** to **Lochend**.
Show the bus no. and company for the first bus, the name of the stop for the transfer,
and the bus no. and company for the second bus.

What am I suposed to do?

- Find all services that visit Craiglockhart
- Find all services that visit Lochend
- Join these two tables ON transfer ? What is transfer ?

```sql
select DISTINCT bus1.num, bus1.company, bus1.name, bus2.num, bus2.company from
  (SELECT DISTINCT r1.num, r1.company, s2.name from route r1
    -- self join on service id (service id is company and bus number)
    -- this gives me all routs for curret service id
    join route r2
      ON (r1.company=r2.company AND r1.num=r2.num)
    -- this gives me starting bus stops with name Craiglockhart
    join stops s1
      ON (r1.stop=s1.id AND s1.name='Craiglockhart')
    -- gives me final route:
    -- list of all the stops for all the buses
    -- which can be reached from Craiglockhart
    join stops s2
      ON (s2.id=r2.stop)
  ) AS bus1
 JOIN
  -- next is simillar to query above
  -- this gives me all the stops for all the buses
  -- which can be reached from Lochend
  (SELECT DISTINCT r1.num, r1.company, s2.name from route r1
    join route r2
      ON (r1.company=r2.company AND r1.num=r2.num)
    join stops s1
      ON (r1.stop=s1.id AND s1.name='Lochend')
    join stops s2
      ON (s2.id=r2.stop)
  ) AS bus2
    -- join gives me full routes
    -- with transfer stops
    -- that can be reached from both of routes
    ON bus1.name=bus2.name
ORDER BY bus1.num, bus1.company, bus1.name, bus2.num, bus2.company
```

That was the hard one !

| num | company |      name      | num | company |
|-----|---------|----------------|-----|---------|
|  10 | LRT     | Princes Street | 65  | LRT     |
|  10 | LRT     | Leith          | 87  | LRT     |
|  10 | LRT     | Leith          | 35  | LRT     |
|  10 | LRT     | Leith          | 34  | LRT     |
|  10 | LRT     | Princes Street | C5  | SMT     |
| ... |         |                |     |         |

Given correct answer

```sql
SELECT bus1.num, bus1.company, name, bus2.num, bus2.company FROM
    (SELECT start1.num, start1.company, stop1.stop
    FROM route AS start1
        JOIN route AS stop1
            (ON start1.num = stop1.num AND start1.company = stop1.company AND start1.stop != stop1.stop)
                WHERE start1.stop = (SELECT id FROM stops WHERE name = 'Craiglockhart')
    ) AS bus1
    JOIN 
        (SELECT start2.num, start2.company, start2.stop 
        FROM route AS start2
            JOIN route AS stop2 ON (start2.num = stop2.num AND start2.company = stop2.company and start2.stop != stop2.stop) 
                WHERE stop2.stop = (SELECT id FROM stops WHERE name = 'Lochend')
        ) AS bus2
        ON bus1.stop = bus2.stop
    JOIN stops 
        ON bus1.stop = stops.id
ORDER BY bus1.num, bus1.company, name, bus2.num, bus2.company 
```