# ER Diyagramı: Mahalle Kütüphanesi

```mermaid
erDiagram
    MEMBER ||--o{ LOAN : "borrows"
    BOOK_COPY ||--o{ LOAN : "is lent in"
    BOOK ||--|{ BOOK_COPY : "has copies"
    PUBLISHER ||--o{ BOOK : "publishes"
    BOOK ||--|{ BOOK_AUTHOR : "written by"
    AUTHOR ||--o{ BOOK_AUTHOR : "writes"

    MEMBER {
        int member_id PK
        string full_name
        string email
        date joined_date
    }
    PUBLISHER {
        int publisher_id PK
        string name
    }
    BOOK {
        int book_id PK
        int publisher_id FK
        string title
        string isbn
        int publication_year
    }
    AUTHOR {
        int author_id PK
        string full_name
        string country
    }
    BOOK_AUTHOR {
        int book_id PK, FK
        int author_id PK, FK
    }
    BOOK_COPY {
        int copy_id PK
        int book_id FK
        string shelf_code
        numeric purchase_price
    }
    LOAN {
        int loan_id PK
        int member_id FK
        int copy_id FK
        date loan_date
        date due_date
        date return_date
    }
```

## Kardinaliteler

- Bir üye birçok ödünç alma (`loan`) yapabilir; her ödünç alma tek üyeye aittir (1:N).
- Bir kitabın (`book`) birden fazla fiziksel kopyası (`book_copy`) olabilir; her kopya tek kitaba aittir (1:N).
- Bir kopya zaman içinde birçok kez ödünç verilebilir (1:N).
- Bir yayınevi birçok kitap yayımlar; her kitabın tek yayınevi vardır (1:N).
- Kitap ve yazar arasında **çoktan çoğa (M:N)** ilişki vardır: bir kitabın birden fazla yazarı, bir yazarın birden fazla kitabı olabilir. Bu ilişki `book_author` ara tablosuyla kurulur.
