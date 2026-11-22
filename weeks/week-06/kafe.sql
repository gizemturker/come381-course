-- Kampüs Kafe: ödev veritabanı
-- Kullanım: createdb kafe  ve  psql -d kafe -f kafe.sql

DROP TABLE IF EXISTS order_item;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS customer;

CREATE TABLE customer (
    customer_id integer PRIMARY KEY,
    full_name   text NOT NULL,
    department  text NOT NULL,
    phone       text,
    age         integer
);

CREATE TABLE product (
    product_id integer PRIMARY KEY,
    name       text NOT NULL,
    category   text NOT NULL,
    price      numeric(6,2) NOT NULL
);

CREATE TABLE orders (
    order_id    integer PRIMARY KEY,
    customer_id integer NOT NULL REFERENCES customer (customer_id),
    order_date  date NOT NULL
);

CREATE TABLE order_item (
    order_id   integer NOT NULL REFERENCES orders (order_id),
    product_id integer NOT NULL REFERENCES product (product_id),
    quantity   integer NOT NULL,
    PRIMARY KEY (order_id, product_id)
);

INSERT INTO customer VALUES
(1, 'Ayşe Demir',   'YBS',        '0532 000 00 01', 20),
(2, 'Mehmet Kaya',  'YBS',        NULL,             21),
(3, 'Elif Yıldız',  'YBS',        '0532 000 00 03', NULL),
(4, 'Can Arslan',   'İşletme',    NULL,             NULL),
(5, 'Zeynep Aksoy', 'İşletme',    '0532 000 00 05', 22),
(6, 'Burak Çelik',  'Hukuk',      '0532 000 00 06', 19),
(7, 'Selin Öztürk', 'Psikoloji',  NULL,             23),
(8, 'Emre Şahin',   'YBS',        '0532 000 00 08', 20);

INSERT INTO product VALUES
(1, 'Çay',            'Sıcak İçecek',  20),
(2, 'Türk Kahvesi',   'Sıcak İçecek',  35),
(3, 'Latte',          'Sıcak İçecek',  60),
(4, 'Limonata',       'Soğuk İçecek',  40),
(5, 'Buzlu Çay',      'Soğuk İçecek',  30),
(6, 'Cheesecake',     'Tatlı',         85),
(7, 'Tost',           'Sandviç',       70),
(8, 'Club Sandviç',   'Sandviç',       90);

-- Emre Şahin (8) henüz sipariş vermedi.
INSERT INTO orders VALUES
(1,  1, '2026-11-02'),
(2,  2, '2026-11-02'),
(3,  1, '2026-11-03'),
(4,  3, '2026-11-04'),
(5,  4, '2026-11-05'),
(6,  5, '2026-11-05'),
(7,  1, '2026-11-09'),
(8,  6, '2026-11-10'),
(9,  2, '2026-11-11'),
(10, 7, '2026-11-12'),
(11, 3, '2026-11-16'),
(12, 5, '2026-11-17');

INSERT INTO order_item VALUES
(1, 3, 1), (1, 6, 1),
(2, 1, 2), (2, 7, 1),
(3, 2, 1), (3, 5, 1),
(4, 8, 1), (4, 4, 1),
(5, 1, 1), (5, 6, 2),
(6, 3, 2), (6, 7, 1),
(7, 4, 2), (7, 8, 1),
(8, 2, 1), (8, 6, 1),
(9, 3, 1), (9, 5, 2),
(10, 7, 1), (10, 1, 1), (10, 4, 1),
(11, 6, 1), (11, 2, 2),
(12, 8, 1), (12, 3, 1);
