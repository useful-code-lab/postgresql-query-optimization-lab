-- Оптимизация Кейса 1: Добавляем индекс
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Проверка (должен появиться Index Scan)
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 45210;

-- Оптимизация Кейса 2: Увеличение памяти сессии или индекс
SET work_mem = '64MB'; 
-- Снова запускаем запрос - теперь Sort Method: quicksort Memory: ...
EXPLAIN ANALYZE SELECT * FROM orders ORDER BY amount DESC LIMIT 100000;

-- Или создание индекса для сортировки "на лету" (Index Scan без Sort вовсе)
CREATE INDEX idx_orders_amount_desc ON orders(amount DESC);
EXPLAIN ANALYZE SELECT * FROM orders ORDER BY amount DESC LIMIT 100000;
