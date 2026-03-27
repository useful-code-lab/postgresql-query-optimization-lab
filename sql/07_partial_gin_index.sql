-- 1. Проблема: Обычный GIN индекс на всю таблицу весит много и замедляет все вставки.
-- Удалим старый индекс для чистоты эксперимента
DROP INDEX IF EXISTS idx_orders_metadata_gin;

-- 2. Создаем ЧАСТИЧНЫЙ GIN индекс
-- Индексируем JSON только для тех заказов, которые НЕ завершены
CREATE INDEX idx_orders_active_metadata_gin 
ON orders USING GIN (metadata)
WHERE status != 'completed';

-- 3. Тестируем: запрос, который попадает в условие индекса
-- Postgres увидит, что статус 'new' подходит под условие "!= completed" и использует индекс
EXPLAIN ANALYZE 
SELECT * FROM orders 
WHERE status = 'new' 
  AND metadata @> '{"retry": 5}';

-- 4. Тестируем: запрос, который НЕ попадает в индекс
-- Тут Postgres сделает Seq Scan, потому что индекс не содержит данных о 'completed'
EXPLAIN ANALYZE 
SELECT * FROM orders 
WHERE status = 'completed' 
  AND metadata @> '{"retry": 5}';
