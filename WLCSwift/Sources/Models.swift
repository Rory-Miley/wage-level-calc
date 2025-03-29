import Foundation

enum Zone: String, CaseIterable {
    case zone4 = "Zone 4"
    case zone5 = "Zone 5"
}

enum Degree: String, CaseIterable {
    case bachelors = "Bachelor's"
    case masters = "Master's"
    case phd = "PhD"
}

struct DegreeRow: Identifiable {
    let id = UUID()
    var degree: Degree
    var yearsExperience: Int
}

class WageCalculatorViewModel: ObservableObject {
    @Published var selectedZone: Zone = .zone4
    @Published var degreeRows: [DegreeRow] = []
    @Published var hasManagerTitle: Bool = false
    @Published var hasManagerialRequirements: Bool = false
    @Published var hasSpecialFeature: Bool = false
    
    var availableDegrees: [Degree] {
        let usedDegrees = Set(degreeRows.map { $0.degree })
        return Degree.allCases.filter { !usedDegrees.contains($0) }
    }
    
    func addDegreeRow() {
        guard degreeRows.count < 3 else { return }
        if let firstAvailableDegree = availableDegrees.first {
            degreeRows.append(DegreeRow(degree: firstAvailableDegree, yearsExperience: 0))
        }
    }
    
    func removeDegreeRow(at index: Int) {
        degreeRows.remove(at: index)
    }
    
    func updateDegree(at index: Int, to newDegree: Degree) {
        degreeRows[index].degree = newDegree
    }
} 