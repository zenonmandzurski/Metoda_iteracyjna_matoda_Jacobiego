//
//  Metoda_iteracyjna_matoda_Jacobiego
//
//  Radoslaw Borysewicz
//

import Foundation

func readMatrix(from file: String) -> [[Double]]? {
    guard let filePath = Bundle.main.path(forResource: file, ofType: "txt") else {
        print("Nie można odnaleźć pliku.")
        return nil
    }
    
    do {
        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        let rows = content.components(separatedBy: .newlines)
        var matrix = [[Double]]()
        
        for row in rows {
            let components = row.components(separatedBy: ",")
            let rowValues = components.compactMap { Double($0) }
            
            // Upewniamy się, że każdy wiersz zawiera tyle samo wartości
            if !rowValues.isEmpty {
                matrix.append(rowValues)
            }
        }
        
        return matrix
    } catch {
        print("Błąd podczas odczytu pliku: \(error)")
        return nil
    }
}

func gaussSeidel(matrix: [[Double]], initialGuess: [Double], tolerance: Double, maxIterations: Int) -> [Double]? {
    let n = matrix.count
    var x = initialGuess
    var xPrev = [Double](repeating: 0.0, count: n)
    var iteration = 0
    var error = tolerance + 1.0
    
    while error > tolerance && iteration < maxIterations {
        for i in 0..<n {
            var sum = 0.0
            if matrix[i].count != n + 1 {
                print("Błąd: Nieprawidłowy rozmiar macierzy.")
                return nil
            }
            
            for j in 0..<n {
                if j != i {
                    sum += matrix[i][j] * x[j]
                }
            }
            
            xPrev[i] = x[i]
            x[i] = (matrix[i][n] - sum) / matrix[i][i]
        }
        
        var maxDiff = 0.0
        for i in 0..<n {
            let diff = abs(x[i] - xPrev[i])
            if diff > maxDiff {
                maxDiff = diff
            }
        }
        error = maxDiff
        iteration += 1
    }
    
    if iteration >= maxIterations {
        print("Osiągnięto limit iteracji bez osiągnięcia zadowalającej dokładności.")
        return nil
    } else if x.contains(where: { $0.isNaN }) {
        print("Algorytm nie zbiega do rozwiązania dla podanych danych.")
        return nil
    } else {
        return x
    }
}

if let coefficients = readMatrix(from: "test") {
    let initialGuess = [0.0, 0.0, 0.0] // Domyślny punkt startowy
    let tolerance = 0.0001 // Dokładność
    let maxIterations = 1000 // Maksymalna liczba iteracji
    
    if let solution = gaussSeidel(matrix: coefficients, initialGuess: initialGuess, tolerance: tolerance, maxIterations: maxIterations) {
        print("Rozwiązanie: \(solution)")
    } else {
        print("Nie udało się znaleźć rozwiązania.")
    }
} else {
    print("Nie można wczytać macierzy z pliku.")
}

