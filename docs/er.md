# Ödev 1 — ER diyagramı
```mermaid
erDiagram
    CATEGORY ||--o{ BOOK : contains
    READER ||--o{ LOAN : borrows
    BOOK ||--o{ LOAN : appears_in
    CATEGORY {
        int category_id PK
        string name UK
    }
    BOOK {
        int book_id PK
        int category_id FK
        string title
        int pages
    }
    READER {
        int reader_id PK
        string full_name
        string email UK
    }
    LOAN {
        int loan_id PK
        int reader_id FK
        int book_id FK
        date loan_date
        date due_date
    }
```
Okuyucu ve kitap arasındaki M:N ilişki loan tablosuyla çözülür. Her ödünç kaydı bir okuyucu ve bir kitaba aittir. Aynı kitabın farklı tarihlerde yeniden ödünç alınması mümkündür.
