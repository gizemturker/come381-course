# NULL Deneyleri

## Deney 1

SELECT COUNT(*), COUNT(phone) FROM customer;

Tahminim: Telefon numarası olmayan müşteriler nedeniyle ikinci sayının daha az çıkacağını düşünüyorum.

Beklenen sonuç: 8 ve 5.

Yorum: COUNT(*) bütün kayıtları sayar. COUNT(phone) ise NULL olan telefon bilgilerini saymaz.

## Deney 2

SELECT AVG(age), SUM(age) / COUNT(*) FROM customer;

Tahminim: Yaşı bilinmeyen müşteriler olduğu için iki işlemin sonucu farklı olacaktır.

Beklenen sonuç: 20.8333 ve 15.

Yorum: AVG(age) sadece yaşı bilinen müşterileri hesaba katar. Diğer işlemde toplam yaş bütün müşteri sayısına bölünür.
