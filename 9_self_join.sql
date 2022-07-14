-- 1)
SELECT COUNT(*) FROM stops;

-- 2)
SELECT id FROM stops
WHERE name = 'Craiglockhart';

-- 3)
SELECT id, name FROM stops
JOIN route ON route.stop = stops.id
WHERE route.num = '4' AND route.company = 'LRT';

-- 4)
SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) = 2;

-- 5)
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop=149;

-- 6)
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name = 'London Road';

-- 7)
SELECT DISTINCT a.company, a.num
FROM route a
JOIN route b ON (a.num = b.num AND a.company = b.company)
WHERE a.stop = 115 AND b.stop = 137;

-- 8)
SELECT a.company, a.num 
FROM route a
JOIN route b ON (a.num = b.num AND a.company = b.company)
JOIN stops stopa ON (a.stop = stopa.id)
JOIN stops stopb ON (b.stop = stopb.id)
WHERE stopa.name = 'Craiglockhart' AND stopb.name = 'Tollcross';

-- 9)
SELECT stopb.name, a.company, a.num 
FROM route a 
JOIN route b ON a.num = b.num AND a.company = b.company
JOIN stops stopa ON stopa.id = a.stop
JOIN stops stopb ON stopb.id = b.stop
WHERE a.company = 'LRT' AND stopa.name = 'Craiglockhart';

-- 10)
SELECT first_bus.num, first_bus.company, first_bus.transfer, second_bus.num, second_bus.company
    FROM(
        SELECT DISTINCT a.num, a.company, stop_b.name AS transfer
            FROM route a
            JOIN route b ON a.num = b.num AND a.company = b.company
            JOIN stops stop_a ON a.stop = stop_a.id
            JOIN stops stop_b ON b.stop = stop_b.id
            WHERE stop_a.name = 'Craiglockhart'
        ) first_bus
    JOIN(
        SELECT DISTINCT b.num, b.company, stop_b.name
            FROM route b
            JOIN route c ON b.num = c.num AND b.company = c.company
            JOIN stops stop_b ON b.stop = stop_b.id
            JOIN stops stop_c ON c.stop = stop_c.id
            WHERE stop_c.name = 'Lochend'

        ) second_bus 
    ON (first_bus.transfer = second_bus.name)
ORDER BY first_bus.num, first_bus.transfer, second_bus.num;