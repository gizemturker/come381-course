# NULL Deneyleri

## Deney 1

SELECT COUNT(*), COUNT(phone) FROM customer;

Tahminim: [Kendi tahminini yaz.]

Beklenen sonuç: 8 ve 5.

Yorum: COUNT(*) müşteri tablosundaki bütün kayıtları sayar. COUNT(phone) ise telefon numarası olmayan müşterileri saymaz.

## Deney 2

SELECT AVG(age), SUM(age) / COUNT(*) FROM customer;

Tahminim: [Kendi tahminini yaz.]

Beklenen sonuç: 20.8333 ve 15.

Yorum: AVG(age) sadece yaşı bilinen müşterilerin ortalamasını alır. İkinci işlemde yaş toplamı bütün müşteri sayısına bölünür. Tam sayı bölmesi nedeniyle sonuç 15 çıkar.
