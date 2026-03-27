-- Active: 1774586206939@@ep-wispy-dawn-amldd42p-pooler.c-5.us-east-1.aws.neon.tech@5432@neondb
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT,
    order_date TIMESTAMP,
    amount DECIMAL,
    status TEXT,
    description TEXT
);

-- Генерируем случайные данные
INSERT INTO orders (user_id, order_date, amount, status, description)
SELECT 
    floor(random() * 100000), 
    now() - (random() * interval '365 days'),
    (random() * 1000),
    (ARRAY['new', 'paid', 'shipped', 'cancelled'])[floor(random() * 4 + 1)],
    md5(random()::text) -- имитация длинного описания
FROM generate_series(1, 1000000);
