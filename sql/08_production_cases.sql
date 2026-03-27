-- Допустим, мы часто запрашиваем только ID и статус для конкретного пользователя
-- Обычный индекс заставит базу прыгать в таблицу за статусом
CREATE INDEX idx_user_status_covering ON orders(user_id) INCLUDE (status);

-- Теперь Postgres заберет и user_id, и status ПРЯМО из индекса
EXPLAIN ANALYZE 
SELECT user_id, status FROM orders WHERE user_id = 500;
-- В плане увидите: Index Only Scan (самый быстрый тип чтения)


-- Как найти, сколько в таблице "мусора" (dead tuples)
SELECT relname, n_dead_tup, n_live_tup, 
       (n_dead_tup::float / n_live_tup::float) as bloat_ratio
FROM pg_stat_user_tables
WHERE relname = 'orders';

-- Команда для очистки (в проде обычно работает автовакуум, но важно знать ручной запуск)
VACUUM ANALYZE orders;

SELECT last_vacuum, last_autovacuum, last_analyze 
FROM pg_stat_user_tables 
WHERE relname = 'orders';


-- Этот запрос проигнорирует обычный индекс:
EXPLAIN ANALYZE 
SELECT * FROM orders WHERE DATE(order_date) = '2023-01-01';

-- Создаем функциональный индекс:
CREATE INDEX idx_orders_date_only ON orders (DATE(order_date));

-- Теперь план изменится на Index Scan


-- ПЛОХО (медленно на больших страницах):
EXPLAIN ANALYZE 
SELECT * FROM orders ORDER BY id LIMIT 10 OFFSET 500000;

-- ХОРОШО (всегда быстро, если есть индекс на ID):
-- Мы передаем ID последней записи с предыдущей страницы
EXPLAIN ANALYZE 
SELECT * FROM orders WHERE id > 500000 ORDER BY id LIMIT 10;

