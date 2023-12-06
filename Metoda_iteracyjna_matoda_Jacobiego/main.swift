//Metody Numeryczne projekt
//Wybrana metoda: Metoda iteracyjna Jackobiego

//Student: Radoslaw Borysewicz
//Numer indeksu: 163708
//Grupa Dziekańska: U2 Semestr

import Foundation

// Funkcja odczytująca macierz z pliku tekstowego
func readMatrix(from file: String) -> [[Double]]? {
    // Sprawdzenie ścieżki do pliku w zasobach aplikacji
    guard let filePath = Bundle.main.path(forResource: file, ofType: "txt") else {
        // Wyświetlenie komunikatu w przypadku braku pliku
        print("Nie można odnaleźć pliku.")
        return nil
    }
    
    do {
        // Odczytanie zawartości pliku tekstowego
        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        // Podział zawartości na wiersze (każda linia to oddzielny wiersz macierzy)
        let rows = content.components(separatedBy: .newlines)
        var matrix = [[Double]]()
        
        // Iteracja przez każdy wiersz odczytany z pliku
        for row in rows {
            // Podział wiersza na poszczególne wartości (oddzielone spacją)
            let components = row.components(separatedBy: " ")
            // Konwersja odczytanych wartości na liczby typu Double
            let rowValues = components.compactMap { Double($0) }
            
            // Dodanie wiersza do macierzy, upewniając się, że zawiera on odpowiednią liczbę wartości
            if !rowValues.isEmpty {
                matrix.append(rowValues)
            }
        }
        
        return matrix // Zwrócenie odczytanej macierzy
    } catch {
        // Wyświetlenie komunikatu w przypadku błędu podczas odczytu pliku
        print("Błąd podczas odczytu pliku: \(error)")
        return nil
    }
}

// Funkcja wykonująca algorytm Gaussa-Seidla
func gaussSeidel(matrix: [[Double]], initialGuess: [Double], tolerance: Double, maxIterations: Int) -> [Double]? {
    let n = matrix.count // Pobranie liczby równań/macierzy kwadratowej
    var x = initialGuess // Ustawienie punktu startowego
    var xPrev = [Double](repeating: 0.0, count: n) // Inicjalizacja poprzedniego wektora rozwiązań
    var iteration = 0 // Licznik iteracji
    var error = tolerance + 1.0 // Inicjalizacja błędu
    
    // Pętla główna algorytmu
    while error > tolerance && iteration < maxIterations {
        // Iteracja po każdym równaniu w macierzy
        for i in 0..<n {
            var sum = 0.0 // Zmienna przechowująca sumę wartości
            if matrix[i].count != n + 1 {
                // Sprawdzenie czy rozmiar macierzy jest prawidłowy
                print("Błąd: Nieprawidłowy rozmiar macierzy.")
                return nil
            }
            
            // Obliczenie wartości dla równania i-tego
            for j in 0..<n {
                if j != i {
                    sum += matrix[i][j] * x[j]
                }
            }
            
            // Aktualizacja wartości i-tej niewiadomej
            xPrev[i] = x[i]
            x[i] = (matrix[i][n] - sum) / matrix[i][i]
        }
        
        // Obliczenie maksymalnej różnicy między kolejnymi iteracjami
        var maxDiff = 0.0
        for i in 0..<n {
            let diff = abs(x[i] - xPrev[i])
            if diff > maxDiff {
                maxDiff = diff
            }
        }
        error = maxDiff // Aktualizacja błędu
        iteration += 1 // Inkrementacja liczby iteracji
    }
    
    // Sprawdzenie warunków zakończenia algorytmu
    if iteration >= maxIterations {
        print("Osiągnięto limit iteracji bez osiągnięcia zadowalającej dokładności.")
        return nil
    } else if x.contains(where: { $0.isNaN }) {
        print("Algorytm nie zbiega do rozwiązania dla podanych danych.")
        return nil
    } else {
        return x // Zwrócenie znalezionego rozwiązania
    }
}

// Odczytanie macierzy z pliku tekstowego
if let coefficients = readMatrix(from: "test") {
    let initialGuess = [0.0, 0.0, 0.0] // Domyślny punkt startowy
    let tolerance = 0.0001 // Poziom dokładności
    let maxIterations = 1000 // Maksymalna liczba iteracji
    
    // Wywołanie funkcji rozwiązującej układ równań metodą Gaussa-Seidla
    if let solution = gaussSeidel(matrix: coefficients, initialGuess: initialGuess, tolerance: tolerance, maxIterations: maxIterations) {
        print("Rozwiązanie: \(solution)") // Wyświetlenie rozwiązania
    } else {
        print("Nie udało się znaleźć rozwiązania.") // Komunikat o niepowodzeniu
    }
} else {
    print("Nie można wczytać macierzy z pliku.") // Komunikat o błędzie odczytu pliku
}

