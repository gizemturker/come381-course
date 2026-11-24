# COME 381 Midterm Project

This project models an event and club management system where members can register for events organized under different categories.
Each event belongs to one category, while members and events have a many-to-many relationship.
The event_registration table resolves this many-to-many relationship and stores registration-specific information such as registration time and rating.
Separate primary keys and foreign keys maintain the relationships between members, events, categories, and registrations.
