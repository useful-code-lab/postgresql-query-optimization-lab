CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    order_date TIMESTAMP NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    status TEXT NOT NULL,
    metadata JSONB -- Для имитации нагрузки на чтение
);
