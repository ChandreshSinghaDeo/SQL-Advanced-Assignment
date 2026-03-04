SQL Advanced Portfolio Project: Sales & Product Analysis
📌 Project Overview
This project demonstrates the application of Advanced SQL techniques to manage and analyze a retail dataset (Products and Sales). It focuses on data integrity, automated logging, and complex reporting structures using MySQL.

🛠️ Key SQL Features Implemented
Data Modeling & Normalization: Established relational integrity using Primary Keys and Foreign Keys to link products to their respective sales records.

Common Table Expressions (CTEs): Developed modular queries to calculate total revenue per product, filtering for high-performance items (Revenue > 3000).

Database Automation (Triggers): Created an AFTER DELETE trigger to maintain a ProductArchive, ensuring that no data is permanently lost even after deletion from the main table.

Modular Programming (Stored Procedures): Built reusable procedures that accept dynamic inputs (Category names) to fetch real-time product lists.

Virtual Tables (Views):

Summary Views: Aggregated data by category to show total product counts and average pricing.

Updatable Views: Demonstrated how to modify underlying table data through a virtual interface.

📊 Business Insights Derived
Identified high-revenue products by joining sales volume with unit pricing.

Categorized inventory to understand average pricing tiers across different departments (Electronics vs. Furniture).

Implemented a fail-safe data recovery system through automated archiving.

📂 File Structure
Advanced SQL.sql: Full source code including schema creation, data insertion, and all advanced queries.
