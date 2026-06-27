from faker import Faker
import random
import pandas as pd

fake = Faker()

continents = {
    "USA": "North America",
    "Canada": "North America",
    "Mexico": "North America",
    "Brazil": "South America",
    "Argentina": "South America",
    "United Kingdom": "Europe",
    "France": "Europe",
    "Germany": "Europe",
    "Spain": "Europe",
    "Italy": "Europe",
    "Switzerland": "Europe",
    "Australia": "Oceania",
    "Japan": "Asia",
    "China": "Asia",
    "India": "Asia",
    "Singapore": "Asia",
    "South Africa": "Africa",
    "Egypt": "Africa"
}

countries = list(continents.keys())

rows = []

for customer_id in range(1, 101):

    gender = random.choice(["Male", "Female"])

    first_name = (
        fake.first_name_male()
        if gender == "Male"
        else fake.first_name_female()
    )

    last_name = fake.last_name()

    country = random.choice(countries)

    rows.append({
        "customerID": customer_id,
        "first_name": first_name,
        "last_name": last_name,
        "email_address": fake.email(),
        "phone_number": fake.phone_number(),
        "address": fake.street_address(),
        "city": fake.city(),
        "state": fake.state(),
        "country": country,
        "continent": continents[country],
        "postal_zip_code": random.randint(10000, 99999),
        "gender": gender
    })

df = pd.DataFrame(rows)

print(df.head())

# Optional: save to CSV
df.to_csv("customers.csv", index=False)