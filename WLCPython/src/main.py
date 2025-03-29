# Define the Z4 and Z5 tables
Z4 = {
    2: 0,
    3: 1,
    4: 2,
    '>4': 3
}

Z5 = {
    4: 0,
    5: 0,
    6: 1,
    7: 1,
    8: 2,
    9: 2,
    10: 2,
    '>=11': 3
}

def get_z_value(z_table, years):
    if z_table == 'Z4':
        table = Z4
    elif z_table == 'Z5':
        table = Z5
    else:
        raise ValueError("Invalid Z table")

    if years in table:
        return table[years]
    elif z_table == 'Z4' and years > 4:
        return table['>4']
    elif z_table == 'Z5' and years >= 11:
        return table['>=11']
    else:
        raise ValueError("Years of experience not found in Z table")

def calculate_wl(Z, EE, SR, MC, MR):
    max_wl = 0

    # Calculate WL for each education experience in EE
    for degree, years in EE.items():
        # Step 1: Calculate the index education level - min education level
        if degree == 'bachelors':
            min_education = 0
        elif degree == 'masters':
            min_education = 1
        elif degree == 'phd':
            min_education = 2
        else:
            raise ValueError("Invalid degree")

        wl = min_education

        # Step 2: Get the corresponding Z table value
        z_table = Z
        z_value = get_z_value(z_table, years)
        wl += z_value

        # Keep the highest WL value
        if wl > max_wl:
            max_wl = wl

    # Step 3: Compare manager code and manager responsibility
    if not MC and MR:
        max_wl += 1

    # Step 4: Add the special requirements value
    max_wl += SR

    # Ensure WL does not exceed 4
    if max_wl > 4:
        max_wl = 4

    return max_wl

def main():
    # Prompt the user for inputs
    Z = input("Enter the job zone (Z4 or Z5): ").strip().upper()
    while Z not in ['Z4', 'Z5']:
        print("Invalid job zone. Please enter either Z4 or Z5.")
        Z = input("Enter the job zone (Z4 or Z5): ").strip().upper()

    EE = {}
    print("Enter education experience (degree and years, e.g., bachelors 4). Type 'done' when finished.")
    while True:
        entry = input("Enter degree and years (e.g., bachelors 4): ").strip().lower()
        if entry == 'done':
            break
        try:
            degree, years = entry.split()
            years = int(years)
            EE[degree] = years
        except ValueError:
            print("Invalid input. Please enter in the format 'degree years'.")

    SR = int(input("Enter special requirements (0-4): "))
    while SR < 0 or SR > 4:
        print("Invalid special requirements. Please enter a value between 0 and 4.")
        SR = int(input("Enter special requirements (0-4): "))

    MC = input("Is there a manager code? (true/false): ").strip().lower()
    while MC not in ['true', 'false']:
        print("Invalid input. Please enter 'true' or 'false'.")
        MC = input("Is there a manager code? (true/false): ").strip().lower()
    MC = MC == 'true'

    MR = input("Does the job have manager responsibility? (true/false): ").strip().lower()
    while MR not in ['true', 'false']:
        print("Invalid input. Please enter 'true' or 'false'.")
        MR = input("Does the job have manager responsibility? (true/false): ").strip().lower()
    MR = MR == 'true'

    # Calculate the wage level
    wl = calculate_wl(Z, EE, SR, MC, MR)
    print(f"Calculated Wage Level (WL): {wl}")

if __name__ == "__main__":
    main()