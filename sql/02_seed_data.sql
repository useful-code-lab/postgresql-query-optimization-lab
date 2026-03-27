-- Генерируем случайные данные
INSERT INTO orders (user_id, order_date, amount, status, description)
SELECT 
    floor(random() * 100000), 
    now() - (random() * interval '365 days'),
    (random() * 1000),
    (ARRAY['new', 'paid', 'shipped', 'cancelled'])[floor(random() * 4 + 1)],
    md5(random()::text) -- имитация длинного описания
FROM generate_series(1, 1000000);
