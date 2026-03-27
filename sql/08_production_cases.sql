-- Допустим, мы часто запрашиваем только ID и статус для конкретного пользователя
-- Обычный индекс заставит базу прыгать в таблицу за статусом
CREATE INDEX idx_user_status_covering ON orders(user_id) INCLUDE (status);

-- Теперь Postgres заберет и user_id, и status ПРЯМО из индекса
EXPLAIN ANALYZE 
SELECT user_id, status FROM orders WHERE user_id = 500;
-- В плане увидите: Index Only Scan (самый быстрый тип чтения)
