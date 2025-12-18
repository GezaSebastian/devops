def calculate_bmi():
    """Oblicza BMI oraz interpretuje wynik."""

    try:
        # Pobranie danych od użytkownika
        weight = float(input("Podaj wagę (kg): "))
        height_cm = float(input("Podaj wzrost (cm): "))

        # Konwersja wzrostu na metry
        height_m = height_cm / 100

        # Obliczenie BMI
        bmi = weight / (height_m ** 2)

        print(f"\nTwoje BMI wynosi: {bmi:.2f}")

        # Interpretacja BMI
        if bmi < 18.5:
            print("Interpretacja: Niedowaga")
        elif 18.5 <= bmi < 25:
            print("Interpretacja: Waga prawidłowa")
        elif 25 <= bmi < 30:
            print("Interpretacja: Nadwaga")
        else:
            print("Interpretacja: Otyłość")

    except ValueError:
        print("Błąd: Wprowadź poprawne wartości liczbowe.")

# Uruchomienie programu
calculate_bmi()
