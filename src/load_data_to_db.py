import pandas as pd
from utils import get_db_engine

def load_data_to_db():

    # Get the connection engine
    engine = get_db_engine()

    # Load cleaned data
    cleaned_file_path = "../data/clean/cleaned_amazon_data.csv"
    df = pd.read_csv(cleaned_file_path)

    # Load data to database
    table_name = "amazon_sales"
    df.to_sql(table_name, engine, if_exists="append", index=False)

    print(f"Successfully loaded data to {table_name} table.")

if __name__ == "__main__":
    load_data_to_db()