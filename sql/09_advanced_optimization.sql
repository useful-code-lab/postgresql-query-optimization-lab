-- Создаем родительскую таблицу (декларативное секционирование)
CREATE TABLE orders_partitioned (
    id SERIAL,
    order_date DATE NOT NULL,
    amount DECIMAL
) PARTITION BY RANGE (order_date);

-- Создаем секции для конкретных месяцев
CREATE TABLE orders_2023_01 PARTITION OF orders_partitioned
    FOR VALUES FROM ('2023-01-01') TO ('2023-02-01');

CREATE TABLE orders_2023_02 PARTITION OF orders_partitioned
    FOR VALUES FROM ('2023-02-01') TO ('2023-03-01');

-- Профит: При запросе за январь Postgres даже не заглянет в февральскую таблицу.
EXPLAIN ANALYZE 
SELECT * FROM orders_partitioned 
WHERE order_date BETWEEN '2023-01-10' AND '2023-01-20';


-- Идеально для логов и архивов заказов
CREATE INDEX idx_orders_brin_date ON orders USING BRIN (order_date);

-- Профит: Индекс весит килобайты вместо гигабайт.
-- В плане увидите: Bitmap Index Scan on idx_orders_brin_date


-- Кейс: Взять один свободный заказ в работу
BEGIN;

SELECT id FROM orders 
WHERE status = 'new' 
LIMIT 1 
FOR UPDATE SKIP LOCKED; -- Тот, кто выполнит это вторым, не будет ждать первого, а сразу возьмет СЛЕДУЮЩИЙ заказ.

UPDATE orders SET status = 'processing' WHERE id = (указанный_id);

COMMIT;
