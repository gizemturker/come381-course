## Ödev 1
Used AI assistance to structure the Mermaid ER diagram, write PostgreSQL DDL schema with identity keys and foreign keys, and draft the README summary.
## Ödev 2

### 1. D6 (Division) Sorgusu Yapay Zeka Denemesi
- **İstenen Prompt:** "PostgreSQL kullanarak bir üyenin veritabanındaki tüm etkinliklere eksiksiz katıldığını bulan SQL division sorgusunu GROUP BY ve HAVING kullanarak yaz."
- **AI Tarafından Verilen Sorgu:**
  ```sql
  SELECT member_id FROM event_registration GROUP BY member_id HAVING COUNT(event_id) = (SELECT COUNT(*) FROM event);