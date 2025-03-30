import Foundation

enum Zone: String, CaseIterable {
    case zone4 = "Zone 4"
    case zone5 = "Zone 5"
    
    var jobZone: JobZone {
        switch self {
        case .zone4: return .z4
        case .zone5: return .z5
        }
    }
}

enum Degree: String, CaseIterable {
    case bachelors = "Bachelor's"
    case masters = "Master's"
    case phd = "PhD"
}

struct DegreeRow: Identifiable {
    let id = UUID()
    var degree: DegreeType
    var yearsExperience: Int
}

class WageCalculatorViewModel: ObservableObject {
    @Published var selectedZone: Zone = .zone4
    @Published var industryStandardEducation: DegreeType = .bachelors
    @Published var degreeRows: [DegreeRow] = []
    @Published var hasManagerTitle: Bool = false
    @Published var hasManagerialRequirements: Bool = false
    @Published var hasSpecialFeature: Bool = false
    
    private let wageCalculator = WageCalculator()
    
    var availableDegrees: [DegreeType] {
        let usedDegrees = Set(degreeRows.map { $0.degree })
        return DegreeType.allCases.filter { !usedDegrees.contains($0) }
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
    
    func updateDegree(at index: Int, to newDegree: DegreeType) {
        degreeRows[index].degree = newDegree
    }
    
    func calculateWageLevel() -> Int {
        let educationExperiences = degreeRows.map { 
            EducationExperience(degree: $0.degree, years: $0.yearsExperience)
        }
        
        return wageCalculator.calculateWageLevel(
            zone: selectedZone.jobZone,
            educationExperiences: educationExperiences,
            specialRequirements: hasSpecialFeature ? 1 : 0,
            hasManagerTitle: hasManagerTitle,
            hasManagerialRequirements: hasManagerialRequirements,
            industryStandardEducation: industryStandardEducation
        )
    }
} 