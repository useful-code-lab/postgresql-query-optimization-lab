-- 1. Смотрим план ДО создания индекса (даже если work_mem большой)
-- Postgres будет использовать Quicksort (сортировку в памяти)
SET work_mem = '64MB';
EXPLAIN ANALYZE 
SELECT id, amount FROM orders ORDER BY amount DESC LIMIT 1000;
-- В выводе ищем: "Sort Method: quicksort"

-- 2. Создаем индекс, который УЖЕ отсортирован
CREATE INDEX idx_orders_amount_desc ON orders(amount DESC);

-- 3. Проверяем план ПОСЛЕ
EXPLAIN ANALYZE 
SELECT id, amount FROM orders ORDER BY amount DESC LIMIT 1000;
-- В выводе должно исчезнуть слово "Sort"! 
-- Вместо него появится "Index Scan using idx_orders_amount_desc"
