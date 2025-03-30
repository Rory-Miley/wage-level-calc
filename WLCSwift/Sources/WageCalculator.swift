import Foundation

// Define the Z4 and Z5 tables
struct ZTable {
    static let z4: [Int: Int] = [
        2: 0,
        3: 1,
        4: 2,
        -1: 3  // -1 represents >4
    ]
    
    static let z5: [Int: Int] = [
        4: 0,
        5: 0,
        6: 1,
        7: 1,
        8: 2,
        9: 2,
        10: 2,
        -1: 3  // -1 represents >=11
    ]
}

enum JobZone: String {
    case z4 = "Z4"
    case z5 = "Z5"
}

enum DegreeType: String, CaseIterable {
    case bachelors = "bachelors"
    case masters = "masters"
    case phd = "phd"
    
    var minEducation: Int {
        switch self {
        case .bachelors: return 0
        case .masters: return 1
        case .phd: return 2
        }
    }
}

struct EducationExperience {
    let degree: DegreeType
    let years: Int
}

class WageCalculator {
    private func getZValue(zone: JobZone, years: Int) -> Int {
        let table = zone == .z4 ? ZTable.z4 : ZTable.z5
        
        if let value = table[years] {
            return value
        }
        
        // Handle special cases
        if zone == .z4 && years > 4 {
            return table[-1] ?? 0
        } else if zone == .z5 && years >= 11 {
            return table[-1] ?? 0
        }
        
        return 0
    }
    
    func calculateWageLevel(
        zone: JobZone,
        educationExperiences: [EducationExperience],
        specialRequirements: Int,
        hasManagerTitle: Bool,
        hasManagerialRequirements: Bool,
        industryStandardEducation: DegreeType
    ) -> Int {
        var maxWageLevel = 0
        let minEducationLevel = industryStandardEducation.minEducation
        
        // Calculate WL for each education experience
        for experience in educationExperiences {
            // Calculate education level difference
            let educationDiff = experience.degree.minEducation - minEducationLevel
            
            // Start with education difference
            var wageLevel = educationDiff
            
            // Add Z table value
            let zValue = getZValue(zone: zone, years: experience.years)
            wageLevel += zValue
            
            // Keep the highest WL value
            if wageLevel > maxWageLevel {
                maxWageLevel = wageLevel
            }
        }
        
        // Compare manager title and managerial requirements
        if !hasManagerTitle && hasManagerialRequirements {
            maxWageLevel += 1
        }
        
        // Add the special requirements value
        maxWageLevel += specialRequirements
        
        // Ensure WL does not exceed 4
        if maxWageLevel <= 0 {
            maxWageLevel = 1
        }
        
        return min(maxWageLevel, 4)
    }
} 