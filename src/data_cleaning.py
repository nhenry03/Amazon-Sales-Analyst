import pandas as pd 

def load_and_clean_data(file_path: str) -> pd.DataFrame:
    """Load and clean the Amazon sales data"""
    # Load the data
    df = pd.read_csv(file_path)

    # Delete unnecessary columns
    columns_to_drop = ['review_id', 'review_title', 'review_content', 'img_link', 'product_link','about_product', 'rating']
    df = df.drop(columns=columns_to_drop)

    # Remove duplicate rows
    df.drop_duplicates(inplace=True)

    # Convert columns to appropriate data types
    df['rating_count'] = (
    df['rating_count']
    .fillna('0')                  # ensure it's string-safe
    .astype(str)                  # convert everything to string
    .str.replace(',', '')         # remove commas
    .astype(int))                 # convert to int
    
    df['discounted_price'] = df['discounted_price'].str.replace('$','').str.replace('₹','').str.replace(',','').astype(float)
    
    df['actual_price'] = df['actual_price'].str.replace('$','').str.replace('₹','').str.replace(',','').astype(float)
    
    df['discount_percentage'] = df['discount_percentage'].str.replace('%','').astype(float)
    df['promotion_start_date'] = pd.to_datetime(df['promotion_start_date'])
    df['promotion_end_date'] = pd.to_datetime(df['promotion_end_date'])

    mask_no_discount = df['discount_percentage'] == 0
    df.loc[mask_no_discount, 'promotion_start_date'] = pd.NA
    df.loc[mask_no_discount, 'promotion_end_date'] = pd.NA

    return df


if __name__ == "__main__":
    RAW_PATH = "../data/raw/amazon_promotions.csv"
    CLEANED_PATH = "../data/clean/cleaned_amazon_data.csv"

    cleaned_data = load_and_clean_data(RAW_PATH)
    cleaned_data.to_csv(CLEANED_PATH, index=False)
    print(f"Cleaned data saved to {CLEANED_PATH}")