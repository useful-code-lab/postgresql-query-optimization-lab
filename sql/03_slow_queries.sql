-- Кейс 1: Seq Scan (Последовательное чтение всей таблицы)
-- Ожидаем: Seq Scan on orders, Cost: высокое, Rows Removed: ~1.49 млн.
EXPLAIN ANALYZE 
SELECT * FROM orders WHERE user_id = 45210;

-- Кейс 2: External Merge (Сортировка на диске)
-- Мы специально ограничили work_mem в docker-compose до 1MB.
-- Ожидаем: Sort Method: external merge Disk: ~40000kB (цифры зависят от данных)
EXPLAIN ANALYZE 
SELECT * FROM orders ORDER BY amount DESC LIMIT 100000;
