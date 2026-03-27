ALTER TABLE orders ADD COLUMN metadata JSONB;

UPDATE orders 
SET metadata = '{"retry": 5, "source": "web"}'::jsonb 
WHERE random() < 0.1;


-- 1. Медленный запрос: ищем внутри JSON без индекса
-- Postgres будет делать Seq Scan, разбирая каждый JSON на лету
EXPLAIN ANALYZE 
SELECT * FROM orders 
WHERE metadata @> '{"retry": 5}'; 
-- @> — это оператор "содержит внутри себя"

-- 2. Создаем GIN-индекс (Generalized Inverted Index)
-- Это специальный индекс для "вложенностей"
CREATE INDEX idx_orders_metadata_gin ON orders USING GIN (metadata);

-- 3. Проверяем план ПОСЛЕ
EXPLAIN ANALYZE 
SELECT * FROM orders 
WHERE metadata @> '{"retry": 5}';
-- В выводе ищем: "Bitmap Index Scan on idx_orders_metadata_gin"
