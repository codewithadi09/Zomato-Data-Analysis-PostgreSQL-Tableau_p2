import csv
import sys 


csv.field_size_limit(sys.maxsize) # Set it to the maximum possible size


input_csv_path = r'C:\Users\Astrophysicist ADI\Downloads\zomato.csv'
output_csv_path = r'C:\Users\Astrophysicist ADI\Downloads\zomato_cleaned.csv'


column_names = [
    'url', 'address', 'name', 'online_order', 'book_table', 'rate', 'votes',
    'phone', 'location', 'rest_type', 'dish_liked', 'cuisines', 'approx_cost(for two people)',
    'reviews_list', 'menu_item', 'listed_in(type)', 'listed_in(city)'
]

print(f"Starting CSV cleaning process...")
print(f"Input: {input_csv_path}")
print(f"Output: {output_csv_path}")

try:
    with open(input_csv_path, 'r', encoding='utf-8', errors='replace') as infile:
        reader = csv.reader(infile)
        header = next(reader) # Read the header row

        print(f"Original CSV Header: {header}")

   
        if header != column_names:
            print("\nWARNING: Detected a mismatch between expected column_names and actual CSV header.")
            print("Expected :", column_names)
            print("Actual   :", header)
            print("Please ensure the 'column_names' list in the script exactly matches your CSV header.")
            print("Proceeding, but be aware of potential column alignment issues if mismatch is significant.\n")

        with open(output_csv_path, 'w', newline='', encoding='utf-8') as outfile:
       
            writer = csv.writer(outfile,
                                delimiter=',',
                                quotechar='"',
                                quoting=csv.QUOTE_MINIMAL # Quotes fields only when necessary
                                # You can change to quoting=csv.QUOTE_ALL if you want every field quoted,
                                # but QUOTE_MINIMAL is usually sufficient and produces smaller files.
                               )

            writer.writerow(header) # Write the original header to the new file

            processed_rows = 0
            malformed_rows_skipped = 0
            for row_num, row in enumerate(reader, start=2): # Start from 2 for actual data rows
                if len(row) == len(column_names):
                    writer.writerow(row)
                    processed_rows += 1
                else:
                    malformed_rows_skipped += 1
                    # print(f"Skipping malformed row {row_num} (incorrect number of columns: {len(row)} vs {len(column_names)}): {row[:5]}...") # Print first few elements
                    # ^ Uncomment the line above if you want to see which rows are skipped
                    pass # Don't print for every skip to avoid flooding console

    print(f"\nCSV cleaning complete!")
    print(f"Total rows processed and written: {processed_rows}")
    print(f"Total malformed rows skipped: {malformed_rows_skipped}")
    print(f"Cleaned CSV saved to: '{output_csv_path}'")
    print("\nNow, use this 'zomato_cleaned.csv' file for your PostgreSQL import.")

except FileNotFoundError:
    print(f"Error: Input file not found at '{input_csv_path}'. Please check the path.")
except Exception as e:
    print(f"An unexpected error occurred: {e}")