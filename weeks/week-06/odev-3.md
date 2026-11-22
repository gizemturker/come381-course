# Ödev 3: Kampüs Kafe'ye SQL ile soru sormak

## Öğrenci bilgileri

| Ad Soyad | Öğrenci No | Bölüm | Şube (2 / 3) | GitHub kullanıcı adı |
|---|---|---|---|---|
|  |  |  |  |  |

## Ödevin niteliği

| | |
|---|---|
| Ders | BİM 381 Veritabanı Sistemleri (Yönetim Bilişim Sistemleri, İİBF) |
| Dönem | 2026-2027 Güz |
| Ödev | Ödev 3: Kampüs Kafe'ye SQL ile soru sormak |
| Tür | Bireysel uygulama ödevi (PostgreSQL) |
| Ağırlık | Altı ödevden biri. Ödevler dönem notunun %20'si; en düşük not atılır. |
| Puan | 100 |
| Süre | Tahmini 2 saat |
| Son teslim | Çarşamba 25 Kasım (şube 2) ve Perşembe 26 Kasım (şube 3), ders saatinde (09:00-12:50) |

## Senaryo

Bir üniversitenin öğrenci kafesi olan Kampüs Kafe, siparişlerini bir veritabanında tutuyor. Veri hazır. Sen kafenin yöneticisine yardım ediyorsun: SQL ile sorularına cevap bulacaksın.

Mailde gelen `kafe.sql` dosyasını kullan. Dört tablo var:

| Tablo | İçinde ne var |
|---|---|
| `customer` | Müşteriler: `customer_id`, `full_name`, `department`, `phone`, `age` (telefon ve yaş boş olabilir) |
| `product` | Ürünler: `product_id`, `name`, `category`, `price` |
| `orders` | Siparişler: `order_id`, `customer_id`, `order_date` |
| `order_item` | Siparişin kalemleri: `order_id`, `product_id`, `quantity` |

Kurulum (terminalde, `kafe.sql` dosyasının olduğu klasörde):

```
createdb kafe
psql -d kafe -f kafe.sql
```

Windows'ta her `psql` ve `createdb` komutuna `-U postgres` ekle. Kurulumu yeniden çalıştırırsan veri sıfırlanır; bu sorun değil.

## Üç küçük örnek

Ödevdeki sorular bunlardan farklı. Önce örneklere bak, sonra kendi sorgularını yaz.

**Filtrele ve sırala** (`WHERE` + `ORDER BY`). Soru: "Sıcak İçecekleri ucuzdan pahalıya sırala."

```sql
SELECT name, price
FROM product
WHERE category = 'Sıcak İçecek'
ORDER BY price;
```

**İki tabloyu birleştir** (`INNER JOIN`). Soru: "1 numaralı siparişte hangi ürünler var?"

```sql
SELECT p.name, oi.quantity
FROM order_item oi
INNER JOIN product p ON p.product_id = oi.product_id
WHERE oi.order_id = 1;
```

**Grupla ve say** (`GROUP BY`). Soru: "Her kategoride kaç ürün var?"

```sql
SELECT category, COUNT(*)
FROM product
GROUP BY category;
```

## Bölüm 1: Sorgular (60 puan)

Dosya: `sorgular.sql`. Her sorgunun üstüne yorum olarak üç şey yaz: numara, Türkçe soru ve "bu sonuç ne işe yarar?" için bir cümle. Örnek biçim:

```sql
-- Q0: Soru buraya.
-- Ne işe yarar: Tek cümleyle buraya.
SELECT ... ;
```

| No | Soru | Kullanacağın konu |
|---|---|---|
| Q1 | Fiyatı 50 TL'den yüksek ürünleri pahalıdan ucuza sırala. | `WHERE` + `ORDER BY` |
| Q2 | 'YBS' bölümündeki müşterilerin adlarını alfabetik sırala. | `WHERE` + `ORDER BY` |
| Q3 | Her siparişin numarasını, tarihini ve müşterinin adını listele. | `INNER JOIN` |
| Q4 | Her sipariş kaleminin ürün adını ve adedini listele. | `INNER JOIN` |
| Q5 | Her müşterinin kaç sipariş verdiğini müşteri adıyla listele. | `JOIN` + `GROUP BY` + `COUNT` |
| Q6 | Her ürün kategorisinin ortalama fiyatını bul. | `GROUP BY` + `AVG` |

Çıktıyı dosyaya al:

```
psql -d kafe -a -f sorgular.sql > sorgular_cikti.txt 2>&1
```

Çıktıyı açıp bak: altı sorgunun altı sonucu da görünmeli.

## Bölüm 2: NULL deneyi (10 puan)

Dosya: `null_deneyi.md`. `NULL` "değer yok" demektir. Sıfır ya da boş yazı değildir. Aşağıdaki iki sorguyla bunun sonucu nasıl değiştirdiğini göreceksin.

Her deney için sırayla şunu yap:

1. Sorguyu çalıştırmadan önce tahminini yaz.
2. Sorguyu çalıştır, çıkan sonucu yaz.
3. Tahminin tuttu mu? Sonucu 1-2 cümleyle yorumla.

**Deney 1**

```sql
SELECT COUNT(*), COUNT(phone) FROM customer;
```

**Deney 2**

```sql
SELECT AVG(age), SUM(age) / COUNT(*) FROM customer;
```

İpucu: `customer` tablosuna bak (`SELECT * FROM customer;`). Telefon ve yaş sütunlarında hangi satırlar boş?

`null_deneyi.md` içinde her deney için üç satır yaz: Tahminim, Sonuç, Yorum.

## Bölüm 3: Değiştir ve geri al (15 puan)

Dosya: `dml.sql`. Burada tabloyu değiştiren komutlar yazacaksın ama veri kalıcı değişmeyecek: her şeyi `ROLLBACK` ile geri alacaksın. `BEGIN` bir işlem başlatır, `ROLLBACK` o işlemdeki her şeyi geri alır.

**Komut 1:** 'Sıcak İçecek' ürünlerinin fiyatını 5 TL artır (`UPDATE`).
**Komut 2:** Var olmayan 999 numaralı ürünü bir siparişe ekle (`INSERT INTO order_item`). Bu komut hata verecek; bunu görmek istiyoruz.

Önemli: PostgreSQL'de bir işlemde hata olunca işlem durur ve `ROLLBACK`'e kadar başka sorgu çalışmaz. Bu yüzden hatalı komut en sonda olmalı. Fiyatları da hatadan önce ve `ROLLBACK`'ten sonra göstereceğiz. Dosyanın iskeleti:

```sql
\set VERBOSITY verbose
BEGIN;

-- Önce: Sıcak İçecek fiyatları
SELECT name, price FROM product WHERE category = 'Sıcak İçecek' ORDER BY product_id;

-- Komut 1: UPDATE'i buraya yaz

-- Sonra: Sıcak İçecek fiyatları (yukarıdaki SELECT'in aynısı)

-- Komut 2: INSERT'i buraya yaz (hata verecek)

ROLLBACK;

-- ROLLBACK sonrası: Sıcak İçecek fiyatları (yine aynı SELECT)
```

`\set VERBOSITY verbose` satırı sayesinde hata mesajında hata kodu (SQLSTATE) görünür. Çıktıda hata kodunu bulacaksın; kodun ne anlama geldiğini de öğren.

Çıktıyı dosyaya al:

```
psql -d kafe -a -f dml.sql > dml_cikti.txt 2>&1
```

Hata mesajı çıktıda görünmeli; sorun yok, ödev bunu bekliyor. Fiyatlar önce ve `ROLLBACK`'ten sonra aynı olmalı, ortadaki fiyatlar 5 TL yüksek olmalı.

## Bölüm 4: Rapor (15 puan)

1 sayfalık rapor. Mailde gönderilen rapor şablonunu aynen kullan; şablon beş bölümü, uzunluğu ve biçimi anlatıyor. Bu ödevde yapay zeka kullanmadıysan 4. bölüme "kullanmadım" yazman yeterli.

## Ne teslim ediyorsun

İki parça teslim edersin.

**(a) GitHub.** Kendi reponda (tüm ödevlerin tek repoda) `odev-3/` klasörü:

Klasör içindeki beş dosya: `sorgular.sql`, `sorgular_cikti.txt`, `null_deneyi.md`, `dml.sql`, `dml_cikti.txt`.

Ayrıca raporun PDF'i `reports/odev-3-rapor.pdf` yoluna girer. Komutlar:

```
git checkout main
git pull
git checkout -b odev-3
# dosyaları ekle
git add .
git commit -m "Ödev 3"
git push -u origin odev-3
```

Sonra GitHub'da Pull Request aç. `gh` kuruluysa: `gh pr create --base main --head odev-3 --title "Ödev 3"`.

Repo bağlantısını bize göndermene gerek yok; derste birlikte bakacağız.

**(b) Basılı rapor.** Raporun A4 çıktısını ilk derste teslim edersin ve bu ödevin yoklama tutanağını imzalarsın.

## Notlandırma

| Bölüm | Ölçüt | Puan | Alınan |
|---|---|---|---|
| Q1 | Çalışır, doğru sonuç (7) + "ne işe yarar" notu (3) | 10 |  |
| Q2 | Çalışır, doğru sonuç (7) + "ne işe yarar" notu (3) | 10 |  |
| Q3 | Çalışır, doğru sonuç (7) + "ne işe yarar" notu (3) | 10 |  |
| Q4 | Çalışır, doğru sonuç (7) + "ne işe yarar" notu (3) | 10 |  |
| Q5 | Çalışır, doğru sonuç (7) + "ne işe yarar" notu (3) | 10 |  |
| Q6 | Çalışır, doğru sonuç (7) + "ne işe yarar" notu (3) | 10 |  |
| NULL Deney 1 | Tahmin (1) + sonuç (2) + yorum (2) | 5 |  |
| NULL Deney 2 | Tahmin (1) + sonuç (2) + yorum (2) | 5 |  |
| DML Komut 1 | Çalışır, fiyat değişimi gösterilmiş | 5 |  |
| DML Komut 2 | Hata kodu (23503) çıktıda görünüyor | 5 |  |
| DML ROLLBACK | Geri alındığı gösterilmiş (fiyatlar eski haline dönmüş) | 5 |  |
| Rapor | 5 bölüm x 3 puan (boş ya da genel bölüm 0-1, dolu ve somut bölüm 3) | 15 |  |
| **Toplam** | | **100** |  |

Rapor teslim edilmezse yalnızca rapor puanı (15) verilmez; ödevin geri kalanı değerlendirilir.

**Geç teslim:** Geç teslim edilen ödev 100 üzerinden değil 80 üzerinden değerlendirilir (20 puan kesilir). Dosyalar ya da basılı rapor son teslimden sonra gelirse bu kural geçerlidir.

Kolay gelsin. Takıldığın yerde derste ya da mailde sor.
