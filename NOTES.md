# NOTES

## Logical errors

- https://sqlzoo.net/w/index.php/Using_Null 

    Solution for **9th** problem like

    ```sql
    select name
    , CASE WHEN (dept = 1 OR dept = 2) THEN
            'Sci'
            ELSE 
            'Art'
    END
    from teacher
    ```
    
    should have guards `dept IS NOT NULL`

- https://sqlzoo.net/wiki/Music_Tutorial

    Solution for **8th** problem gets the same result as correct, but my result is "wrong"

    ```sql
    select song, count(DISTINCT album) times from track
    group by song
    having times>2
    ```

    My "wrong" results

    |            song            | times |
    |----------------------------|-------|
    | Angel                      |     3 |
    | Best Is Yet to Come        |     3 |
    | Dancing in the Dark        |     3 |
    | From This Moment On        |     4 |
    | I Love You                 |     4 |
    | I've Got You Under My Skin |     3 |
    | Love for Sale              |     3 |
    | Night and Day              |     4 |
    | Once Upon a Time           |     3 |
    | One                        |     3 |
    | Smile                      |     5 |
    | Too Much                   |     3 |

    Correct answer

    |            song            | COUNT(DISTINC.. |
    |----------------------------|-----------------|
    | Angel                      |               3 |
    | Best Is Yet to Come        |               3 |
    | Dancing in the Dark        |               3 |
    | From This Moment On        |               4 |
    | I Love You                 |               4 |
    | I've Got You Under My Skin |               3 |
    | Love For Sale              |               3 |
    | Night And Day              |               4 |
    | Once upon a Time           |               3 |
    | One                        |               3 |
    | Smile                      |               5 |
    | Too Much                   |               3 |

    **Solution**:

    ```sql
    select song, count(DISTINCT asin) as times
        from album join track on asin=album
        group by song
        having count(DISTINCT asin)>2
    ```
    I have to ask about this problem, why do we need `join` here ?

- https://sqlzoo.net/wiki/NSS_Tutorial

    There is no good explanations about table. Especially for those people who see that survey first time in their life.
    Thus it is hard to solve problem when you don't know what fields of the table represent.

- https://sqlzoo.net/wiki/Self_join

    Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'.

    Problem 8 correct solution

    ```sql
    SELECT a.company, a.num "bus num"
    FROM route a JOIN route b ON
    (a.company=b.company AND a.num=b.num)
    JOIN stops stopa ON (a.stop=stopa.id AND stopa.name='Craiglockhart')
    JOIN stops stopb ON (b.stop=stopb.id AND stopb.name='Tollcross')
    ```

    I can get ALL services which stop on Craiglockhart, and all services which stop on Tollcross. And from these I see I can use `LOW 315` to get to **Tollcross** then I can use `LRT 47` to get to **Craiglockhart**. But there is no **LOW** service in the correct answer. Why ?

    Services which stop on Tollcross `select company, num from route join stops on (stop=id) where stops.name='Tollcross'`

    | company | num |
    |---------|-----|
    | LRT     |  10 |
    | LRT     |  11 |
    | LRT     |  15 |
    | LRT     |  16 |
    | LRT     |  17 |
    | LRT     |  23 |
    | LRT     |  24 |
    | LRT     |  27 |
    | LOW     | 315 |
    | LRT     |  37 |
    | LRT     |  45 |
    | LRT     |  47 |

    Services which stop on Craiglockhart `select company, num from route join stops on (stop=id) where stops.name='Craiglockhart'`

    | company | num |
    |---------|-----|
    | LRT     |  10 |
    | LRT     |  27 |
    | LRT     |   4 |
    | LRT     |  45 |
    | LRT     |  47 |

    **Solution**: Probably problem explanation means "give services with no bus transfer".