# 🛒 Amazon Sales Analytics

An end-to-end data analytics project that processes raw Amazon product and promotion data — from CSV ingestion and cleaning, through a local PostgreSQL database, to SQL-driven business insights and a Power BI dashboard.

---

## 📁 Project Structure

```
Amazon Sales Analytics Project/
├── data/
│   ├── raw/                    # Original CSV dataset
│   └── clean/                  # Cleaned & processed CSV output
├── src/
│   ├── data_cleaning.py        # Data cleaning & transformation logic
│   ├── load_data_to_db.py      # Loads cleaned data into PostgreSQL
│   └── utils.py                # Database connection helper (SQLAlchemy)
├── sql/
│   ├── schema.sql              # Table definition for PostgreSQL
│   └── analysis_queries.sql    # Business intelligence SQL queries
├── .env                        # Environment variables (not tracked)
├── .gitignore
└── README.md
```

---

## 🧰 Tech Stack

| Layer | Tool |
|---|---|
| **Language** | Python 3 |
| **Data Manipulation** | pandas |
| **Database** | PostgreSQL (local) |
| **ORM / DB Connector** | SQLAlchemy |
| **SQL Analysis** | PostgreSQL SQL |
| **Visualization** | Power BI |
| **Environment Management** | python-dotenv, `.venv` |
| **Version Control** | Git & GitHub |

---

## ⚙️ Pipeline Overview

### 1. 🧹 Data Cleaning (`src/data_cleaning.py`)

The raw CSV contained several issues that were resolved programmatically:

- **Dropped irrelevant columns**: `review_id`, `review_title`, `review_content`, `img_link`, `product_link`, `about_product`, `rating` — these were either redundant or out of scope for this analysis.
- **Removed duplicate rows** to ensure data integrity.
- **Standardised numeric fields**:
  - `rating_count` — stripped commas, filled nulls, cast to `int`
  - `discounted_price` / `actual_price` — removed currency symbols (`₹`, `$`, `,`), cast to `float`
  - `discount_percentage` — stripped `%` symbol, cast to `float`
- **Parsed promotion dates**: Converted `promotion_start_date` and `promotion_end_date` to proper `datetime` types.
- **Nullified promotion dates for non-discounted products**: Any product with a `discount_percentage` of `0` had its promotion dates set to `NULL` — since a 0% discount is not an active promotion.

### 2. 🗄️ Database Loading (`src/load_data_to_db.py` + `sql/schema.sql`)

- A PostgreSQL table `amazon_sales` was created using a defined schema with appropriate data types (`VARCHAR`, `TEXT`, `NUMERIC`, `DATE`, `INT`, `SERIAL`).
- The cleaned DataFrame was loaded into PostgreSQL via `pandas.DataFrame.to_sql()` using a SQLAlchemy engine.
- Database credentials are stored securely in a `.env` file (excluded from version control).

### 3. 🔍 SQL Analysis (`sql/analysis_queries.sql`)

Business questions answered via SQL queries directly against the PostgreSQL database:

| # | Question |
|---|---|
| 1 | Which categories have the highest average discount percentage? |
| 2 | Which product in each category has the highest discount? |
| 3 | Which product has the longest promotion period? |
| 4 | Which user has written the most reviews? |
| 5 | Which user leads reviews in each category? |
| 6 | What is the total number of reviews per category? |
| 7 | Does a discount ≥ 50% lead to higher customer engagement? |
| 8 | Which month had the most promotions starting? |

---

## 📊 Key Insights

### 🏷️ Discounts & Pricing
- Certain product categories consistently offer significantly higher average discount percentages than others, revealing where Amazon sellers are most competitive.
- Within each category, specific products stand out as having exceptionally aggressive discounts — useful for identifying loss-leaders or promotional anchors.

### 💬 Customer Engagement
- Products with a discount of **≥ 50%** were compared against lower-discount products by average `rating_count` (a proxy for engagement/sales volume). This reveals whether deep discounts actually drive more customer interaction.

### 📅 Promotion Patterns
- Some products run promotions spanning significantly longer periods than others, indicating strategic long-term visibility campaigns.
- Monthly analysis of promotion start dates uncovers **seasonal trends** — identifying which months sellers most aggressively launch promotions (e.g., pre-holiday, sale seasons).

### ⭐ Review Behaviour
- A small number of users account for a disproportionately large share of reviews, highlighting power reviewers.
- Category-level review counts reveal which product segments have the most engaged communities.

---

## 📈 Dashboard

> 🚧 *Power BI dashboard coming soon — will be added here once published.*

The dashboard will visualise:
- Average discount by category
- High vs. Low discount engagement comparison (clustered bar)
- Top products by promotion duration (horizontal bar)
- Promotions started per month (column chart)
- Review volume by category

---

## 🚀 Getting Started

### Prerequisites
- Python 3.10+
- PostgreSQL installed and running locally
- A `.env` file in the project root with the following:

```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=your_database_name
DB_USER=your_username
DB_PASSWORD=your_password
```

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/nhenry03/Amazon-Sales-Analyst.git
cd Amazon-Sales-Analyst

# 2. Create and activate virtual environment
python -m venv .venv
.venv\Scripts\activate       # Windows

# 3. Install dependencies
pip install pandas sqlalchemy psycopg2-binary python-dotenv

# 4. Create the database table
# Run sql/schema.sql against your PostgreSQL database

# 5. Clean the raw data
python src/data_cleaning.py

# 6. Load cleaned data into the database
python src/load_data_to_db.py

# 7. Run the analysis queries
# Open sql/analysis_queries.sql in pgAdmin, DBeaver, or any PostgreSQL client
```

---

## 📌 Notes

- **Market**: This dataset is based on the **Indian Amazon marketplace** — all prices are originally in INR (`₹`).
- **Original Dataset**: Sourced from Kaggle — [Amazon Sales Dataset by karkavelrajaj](https://www.kaggle.com/datasets/karkavelrajaj/amazon-sales-dataset).
- **Promotion Dates**: The `promotion_start_date` and `promotion_end_date` columns **do not exist in the original dataset** — they were added manually for training and analytical purposes only.
