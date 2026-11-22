-- =====================================================================
--  VETERİNER KLİNİĞİ VERİTABANI  (PostgreSQL)
-- ---------------------------------------------------------------------
--  Senaryo:
--  Bir veteriner kliniği müşterilerini (hayvan sahiplerini), onların
--  hayvanlarını, klinikte çalışan veterinerleri ve yapılan muayeneleri
--  kaydetmek istiyor. Muayene sonunda hayvana ilaç yazılabiliyor.
--
--  Kurallar (ER diyagramındaki ilişkiler):
--   * Bir sahibin birden çok hayvanı olabilir; her hayvanın tek sahibi
--     vardır.                                   -> SAHIP 1 : N HAYVAN
--   * Bir hayvan birçok kez, farklı veterinerlerce muayene edilebilir;
--     bir veteriner birçok hayvana bakar.       -> HAYVAN N : M VETERINER
--     Bu çoktan-çoğa ilişkinin kendi bilgileri (tarih, teşhis, ücret)
--     olduğu için MUAYENE adında ayrı bir tabloya dönüşür.
--   * Bir muayenede birden çok ilaç yazılabilir; bir ilaç birçok
--     muayenede yazılabilir.                   -> MUAYENE N : M ILAC
--     Ara tablo: RECETE_KALEMI (doz, gün sayısı).
-- =====================================================================

DROP TABLE IF EXISTS recete_kalemi, ilac, muayene, veteriner, hayvan, sahip CASCADE;

-- 1) SAHİP --------------------------------------------------------------
CREATE TABLE sahip (
    sahip_id   SERIAL       PRIMARY KEY,
    ad         VARCHAR(50)  NOT NULL,
    soyad      VARCHAR(50)  NOT NULL,
    telefon    VARCHAR(15)  NOT NULL UNIQUE,
    eposta     VARCHAR(100)
);

-- 2) HAYVAN  (SAHIP 1:N HAYVAN) ----------------------------------------
CREATE TABLE hayvan (
    hayvan_id     SERIAL      PRIMARY KEY,
    sahip_id      INT         NOT NULL
                  REFERENCES sahip(sahip_id) ON DELETE CASCADE,
    ad            VARCHAR(50) NOT NULL,
    tur           VARCHAR(20) NOT NULL
                  CHECK (tur IN ('Kedi','Köpek','Kuş','Tavşan','Diğer')),
    cins          VARCHAR(50),
    dogum_tarihi  DATE        CHECK (dogum_tarihi <= CURRENT_DATE)
);

-- 3) VETERİNER ----------------------------------------------------------
CREATE TABLE veteriner (
    veteriner_id  SERIAL       PRIMARY KEY,
    ad            VARCHAR(50)  NOT NULL,
    soyad         VARCHAR(50)  NOT NULL,
    diploma_no    VARCHAR(20)  NOT NULL UNIQUE,
    uzmanlik      VARCHAR(50)
);

-- 4) MUAYENE  (HAYVAN N:M VETERINER, ilişki öznitelikleriyle) ------------
CREATE TABLE muayene (
    muayene_id    SERIAL        PRIMARY KEY,
    hayvan_id     INT           NOT NULL
                  REFERENCES hayvan(hayvan_id) ON DELETE CASCADE,
    veteriner_id  INT           NOT NULL
                  REFERENCES veteriner(veteriner_id),
    tarih         TIMESTAMP     NOT NULL DEFAULT now(),
    sikayet       TEXT,
    teshis        TEXT,
    ucret         NUMERIC(8,2)  NOT NULL CHECK (ucret >= 0)
);

-- 5) İLAÇ ---------------------------------------------------------------
CREATE TABLE ilac (
    ilac_id  SERIAL       PRIMARY KEY,
    ad       VARCHAR(100) NOT NULL UNIQUE,
    birim    VARCHAR(20)  NOT NULL          -- tablet, ml, damla ...
);

-- 6) REÇETE KALEMİ  (MUAYENE N:M ILAC) ----------------------------------
CREATE TABLE recete_kalemi (
    muayene_id  INT  NOT NULL REFERENCES muayene(muayene_id) ON DELETE CASCADE,
    ilac_id     INT  NOT NULL REFERENCES ilac(ilac_id),
    doz         VARCHAR(50) NOT NULL,       -- ör. '1 tablet, günde 2'
    gun_sayisi  INT  NOT NULL CHECK (gun_sayisi > 0),
    PRIMARY KEY (muayene_id, ilac_id)       -- aynı ilaç aynı muayenede 1 kez
);

-- =====================================================================
--  ÖRNEK VERİ
-- =====================================================================
INSERT INTO sahip (ad, soyad, telefon, eposta) VALUES
 ('Ayşe',  'Yılmaz', '05321112233', 'ayse@ornek.com'),
 ('Mehmet','Kaya',   '05334445566', NULL),
 ('Zeynep','Demir',  '05357778899', 'zeynep@ornek.com');

INSERT INTO hayvan (sahip_id, ad, tur, cins, dogum_tarihi) VALUES
 (1, 'Pamuk',  'Kedi',   'Van Kedisi',      '2021-04-10'),
 (1, 'Karabaş','Köpek',  'Kangal',          '2019-08-22'),
 (2, 'Maviş',  'Kuş',    'Muhabbet Kuşu',   '2023-02-01'),
 (3, 'Tarçın', 'Köpek',  'Golden Retriever','2020-11-05');

INSERT INTO veteriner (ad, soyad, diploma_no, uzmanlik) VALUES
 ('Can',  'Öztürk', 'VET-1001', 'Dahiliye'),
 ('Elif', 'Arslan', 'VET-1002', 'Cerrahi');

INSERT INTO muayene (hayvan_id, veteriner_id, tarih, sikayet, teshis, ucret) VALUES
 (1, 1, '2026-10-01 10:30', 'İştahsızlık',     'Mide enfeksiyonu', 750.00),
 (2, 2, '2026-10-03 14:00', 'Patisinde yara',  'Kesik, dikiş atıldı', 1200.00),
 (1, 2, '2026-10-15 09:15', 'Kontrol',         'İyileşmiş', 400.00),
 (4, 1, '2026-10-20 16:45', 'Kaşıntı',         'Alerjik dermatit', 900.00);

INSERT INTO ilac (ad, birim) VALUES
 ('Amoksisilin 250 mg', 'tablet'),
 ('Probiyotik Macun',   'ml'),
 ('Antihistaminik',     'tablet');

INSERT INTO recete_kalemi (muayene_id, ilac_id, doz, gun_sayisi) VALUES
 (1, 1, '1 tablet, günde 2', 7),
 (1, 2, '2 ml, günde 1',     5),
 (2, 1, '1 tablet, günde 2', 10),
 (4, 3, '1 tablet, günde 1', 14);

-- =====================================================================
--  ÖRNEK SORGULAR
-- =====================================================================

-- a) Her hayvan ve sahibi
SELECT h.ad AS hayvan, h.tur, s.ad || ' ' || s.soyad AS sahip
FROM hayvan h JOIN sahip s ON s.sahip_id = h.sahip_id
ORDER BY sahip;

-- b) Muayene geçmişi: hangi hayvana hangi veteriner baktı
SELECT m.tarih::date, h.ad AS hayvan, v.ad || ' ' || v.soyad AS veteriner,
       m.teshis, m.ucret
FROM muayene m
JOIN hayvan    h ON h.hayvan_id    = m.hayvan_id
JOIN veteriner v ON v.veteriner_id = m.veteriner_id
ORDER BY m.tarih;

-- c) Bir muayenenin reçetesi
SELECT m.muayene_id, h.ad AS hayvan, i.ad AS ilac, r.doz, r.gun_sayisi
FROM recete_kalemi r
JOIN muayene m ON m.muayene_id = r.muayene_id
JOIN hayvan  h ON h.hayvan_id  = m.hayvan_id
JOIN ilac    i ON i.ilac_id    = r.ilac_id
ORDER BY m.muayene_id;

-- d) Sahip başına toplam muayene ücreti
SELECT s.ad || ' ' || s.soyad AS sahip, COUNT(m.muayene_id) AS muayene_sayisi,
       COALESCE(SUM(m.ucret), 0) AS toplam_ucret
FROM sahip s
LEFT JOIN hayvan  h ON h.sahip_id  = s.sahip_id
LEFT JOIN muayene m ON m.hayvan_id = h.hayvan_id
GROUP BY s.sahip_id
ORDER BY toplam_ucret DESC;
