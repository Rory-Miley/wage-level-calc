import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WageCalculatorViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // ASCII Art Title
                Text("""
                    ██╗    ██╗ █████╗  ██████╗ ███████╗      ██████╗ █████╗ ██╗      ██████╗
                    ██║    ██║██╔══██╗██╔════╝ ██╔════╝     ██╔════╝██╔══██╗██║     ██╔════╝
                    ██║ █╗ ██║███████║██║  ███╗█████╗       ██║     ███████║██║     ██║     
                    ██║███╗██║██╔══██║██║   ██║██╔══╝       ██║     ██╔══██║██║     ██║     
                    ╚███╔███╔╝██║  ██║╚██████╔╝███████╗     ╚██████╗██║  ██║███████╗╚██████╗
                     ╚══╝╚══╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝      ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝
                """)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.blue)
                .padding(.bottom, 20)
                
                // Zone Selection
                Picker("Zone", selection: $viewModel.selectedZone) {
                    ForEach(Zone.allCases, id: \.self) { zone in
                        Text(zone.rawValue).tag(zone)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                // Industry Standard Education
                HStack {
                    Text("Industry Standard Education:")
                    Picker("Industry Standard", selection: $viewModel.industryStandardEducation) {
                        ForEach(DegreeType.allCases, id: \.self) { degree in
                            Text(degree.rawValue.capitalized).tag(degree)
                        }
                    }
                    .frame(width: 200)
                }
                
                // Degree Rows
                VStack(alignment: .leading, spacing: 10) {
                    Text("Degree Levels")
                        .font(.headline)
                    
                    ForEach($viewModel.degreeRows) { $row in
                        HStack {
                            Picker("Degree", selection: $row.degree) {
                                ForEach(viewModel.availableDegrees, id: \.self) { degree in
                                    Text(degree.rawValue.capitalized).tag(degree)
                                }
                                // Include the current degree in the picker
                                Text(row.degree.rawValue.capitalized).tag(row.degree)
                            }
                            .frame(width: 150)
                            
                            Stepper("Years Experience: \(row.yearsExperience)", value: $row.yearsExperience, in: 0...11)
                            
                            Button(action: {
                                if let index = viewModel.degreeRows.firstIndex(where: { $0.id == row.id }) {
                                    viewModel.removeDegreeRow(at: index)
                                }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    Button(action: {
                        viewModel.addDegreeRow()
                    }) {
                        Label("Add Degree Row", systemImage: "plus.circle.fill")
                    }
                    .disabled(viewModel.degreeRows.count >= 3)
                }
                
                // Toggles and Wage Level
                HStack {
                    // Toggles
                    VStack(alignment: .leading, spacing: 10) {
                        Toggle("Has Manager in Title", isOn: $viewModel.hasManagerTitle)
                        Toggle("Has Managerial Requirements", isOn: $viewModel.hasManagerialRequirements)
                        Toggle("Has Special Feature", isOn: $viewModel.hasSpecialFeature)
                    }
                    
                    Spacer()
                    
                    // Wage Level Display
                    VStack(alignment: .center) {
                        Text("Wage Level:")
                            .font(.headline)
                        Text("\(viewModel.calculateWageLevel())")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.blue)
                    }
                    .frame(width: 200)
                }
            }
            .padding()
        }
        //.frame(minWidth: 500, minHeight: 300)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif 