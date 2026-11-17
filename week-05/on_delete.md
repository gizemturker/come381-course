# Silme Politikaları (ON DELETE)

Bu bölümde şemadaki her foreign key için silme davranışı belirlenmiştir.

| Foreign key | Ebeveyn → çocuk | Seçim | Neden | Diğer seçenek neden olmadı |
|---|---|---|---|---|
| `fk_event_category` | `category` → `event` | `NO ACTION` | Bir kategoriye bağlı etkinlikler varken kategorinin yanlışlıkla silinmesini engeller. Önce bağlı etkinliklerin açıkça ele alınması gerekir. | `CASCADE` seçilseydi bir kategoriyi silmek ona bağlı bütün etkinlikleri de silebilirdi; bu senaryoda fazla yıkıcıdır. |
| `fk_registration_member` | `member` → `event_registration` | `CASCADE` | Bir üye silindiğinde sadece o üyeye ait kayıt satırlarının kalmasının anlamı yoktur. | `NO ACTION` üyeyi, geçmiş kayıtları tek tek silmeden silmeyi engellerdi. |
| `fk_registration_event` | `event` → `event_registration` | `CASCADE` | Bir etkinlik silindiğinde o etkinliğe bağlı kayıtlar bağımsız olarak anlamlı değildir. | `NO ACTION` etkinliği silmeden önce tüm kayıtların elle temizlenmesini gerektirirdi. |

## CASCADE kanıtı

`fk_registration_member` için `member_id = 2` kullanılarak silme öncesi ve sonrası kayıt sayısı kontrol edildi.

```sql
SELECT count(*) AS before_delete
FROM event_registration
WHERE member_id = 2;

DELETE FROM member
WHERE member_id = 2;

SELECT count(*) AS after_delete
FROM event_registration
WHERE member_id = 2;
```

Gerçek çıktı:

```text
 before_delete
---------------
             2

DELETE 1

 after_delete
--------------
            0
```

Sonuç: Üye silindiğinde ona ait iki `event_registration` satırı da otomatik olarak silindi; `ON DELETE CASCADE` beklendiği gibi çalıştı.

## RESTRICT ve NO ACTION farkı

PostgreSQL'de `NO ACTION` varsayılan davranıştır ve foreign key kontrolü ertelenebilir bir constraint kullanılıyorsa kontrol daha sonra yapılabilir; `RESTRICT` ise daha katıdır ve kontrolün ertelenmesine izin vermez.
