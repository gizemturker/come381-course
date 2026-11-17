# ER Diagram

This system manages members registering for events in different categories. Each event belongs to one category. A member can register for many events, and an event can have many members. The many-to-many relationship between members and events is represented by event_registration.

```mermaid
erDiagram
    MEMBER ||--o{ EVENT_REGISTRATION : registers
    EVENT ||--o{ EVENT_REGISTRATION : has
    CATEGORY ||--o{ EVENT : contains

    MEMBER {
        int member_id PK
        string full_name
        string email
        string city
        string status
    }

    CATEGORY {
        int category_id PK
        string name
    }

    EVENT {
        int event_id PK
        int category_id FK
        string title
        date start_date
        date end_date
        int capacity
    }

    EVENT_REGISTRATION {
        int registration_id PK
        int member_id FK
        int event_id FK
        datetime registered_at
        int rating
    }
```
