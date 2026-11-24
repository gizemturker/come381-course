# NULL Deneyi (`null_deneyi.md`)

## Deney 1

```sql
SELECT COUNT(*), COUNT(phone) FROM customer;
```

- **Tahminim:** Tabloda 8 müşteri bulunduğu için `COUNT(*)` ifadesinin 8, telefon alanı 3 müşteride boş (`NULL`) bırakıldığı için `COUNT(phone)` ifadesinin 5 vereceğini tahmin ettim.
- **Sonuç:**
  ```text
   count | count 
  -------+-------
       8 |     5
  (1 row)
  ```
- **Yorum:** Tahminim doğru çıktı. `COUNT(*)` tablodaki toplam satır sayısını verirken, `COUNT(phone)` yalnızca telefon sütunu `NULL` olmayan kayıtları saymıştır.

## Deney 2

```sql
SELECT AVG(age), SUM(age) / COUNT(*) FROM customer;
```

- **Tahminim:** Yaşı girilmiş 6 müşterinin yaş toplamı 125 olduğundan `AVG(age)` 125/6 ile yaklaşık 20.83 çıkacak, `SUM(age) / COUNT(*)` ise toplamı tüm müşteri sayısı olan 8'e böldüğü için 15 çıkacaktır.
- **Sonuç:**
  ```text
           avg         | ?column? 
  ---------------------+----------
   20.8333333333333333 |       15
  (1 row)
  ```
- **Yorum:** Tahminim tuttu. `AVG(age)` yaş sütunu `NULL` olan 2 müşteriyi hesaba hiç katmazken, `SUM(age) / COUNT(*)` ifadesi paydaya 8 müşterinin tamamını aldığı için ortalamayı olduğundan düşük hesaplamıştır.
