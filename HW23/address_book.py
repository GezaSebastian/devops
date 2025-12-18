# Lista słowników – książka adresowa
address_book = []


def add_contact(first_name, last_name, phone):
    contact = {
        "imie": first_name,
        "nazwisko": last_name,
        "tel": phone
    }
    address_book.append(contact)


def show_contacts():
    if not address_book:
        print("Książka adresowa jest pusta.")
        return

    print("\n--- Lista kontaktów ---")
    for index, contact in enumerate(address_book, start=1):
        print(f"{index}. {contact['imie']} {contact['nazwisko']} | tel: {contact['tel']}")


def search_contact(query):
    query = query.lower()
    print(f"\nWyniki wyszukiwania dla: '{query}'")

    found = False
    for contact in address_book:
        if query in contact["imie"].lower() or query in contact["nazwisko"].lower():
            print(f"{contact['imie']} {contact['nazwisko']} | tel: {contact['tel']}")
            found = True

    if not found:
        print("Brak pasujących kontaktów.")


def word_counter(text):
    # Usunięcie interpunkcji i zamiana na małe litery
    for char in ",.!?":
        text = text.replace(char, "")

    text = text.lower()
    words = text.split()

    word_counts = {}

    # Zliczanie słów
    for word in words:
        word_counts[word] = word_counts.get(word, 0) + 1

    # Znalezienie maksymalnej liczby wystąpień
    max_count = max(word_counts.values())

    # Lista najczęściej występujących słów
    most_common_words = [
        word for word, count in word_counts.items() if count == max_count
    ]

    return most_common_words, max_count

# Zarządzanie kontaktami
add_contact("Jan", "Kowalski", "123456789")
add_contact("Anna", "Nowak", "987654321")
add_contact("Piotr", "Kaczmarek", "555666777")

show_contacts()
search_contact("kow")

# Analiza Tekstu (Licznik Słów)
text = "Python jest super. Python jest prosty i Python jest potężny!"
words, count = word_counter(text)

print("\nNajczęściej występujące słowo(a):", words)
print("Liczba wystąpień:", count)
