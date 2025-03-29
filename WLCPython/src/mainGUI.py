import sys
from PyQt5.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout, 
                           QHBoxLayout, QLabel, QComboBox, QPushButton, 
                           QTableWidget, QTableWidgetItem, QMessageBox, 
                           QCheckBox, QSpinBox)

# Define the Z4 and Z5 tables
Z4 = {2: 0, 3: 1, 4: 2, '>4': 3}
Z5 = {4: 0, 5: 0, 6: 1, 7: 1, 8: 2, 9: 2, 10: 2, '>=11': 3}

class WageCalculator(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Wage Level Calculator")
        self.setMinimumWidth(600)
        self.setMinimumHeight(400)

        # Create main widget and layout
        main_widget = QWidget()
        self.setCentralWidget(main_widget)
        layout = QVBoxLayout(main_widget)

        # Job Zone Selection
        zone_layout = QHBoxLayout()
        zone_label = QLabel("Job Zone:")
        self.zone_combo = QComboBox()
        self.zone_combo.addItems(["Z4", "Z5"])
        zone_layout.addWidget(zone_label)
        zone_layout.addWidget(self.zone_combo)
        zone_layout.addStretch()
        layout.addLayout(zone_layout)
        
        # Industry standard Selection
        is_layout = QHBoxLayout()
        is_label = QLabel("Industry standard education:")
        self.is_combo = QComboBox()
        self.is_combo.addItems(["Bachelors","Masters","phd"])
        is_layout.addWidget(is_label)
        is_layout.addWidget(self.is_combo)
        is_layout.addStretch()
        layout.addLayout(is_layout)

        # Education Experience Table
        layout.addWidget(QLabel("Education Experience:"))
        self.edu_table = QTableWidget(0, 2)
        self.edu_table.setHorizontalHeaderLabels(["Degree", "Years"])
        self.edu_table.horizontalHeader().setStretchLastSection(True)
        layout.addWidget(self.edu_table)

        # Add/Remove Education buttons
        btn_layout = QHBoxLayout()
        add_btn = QPushButton("Add Education")
        remove_btn = QPushButton("Remove Selected")
        add_btn.clicked.connect(self.add_education)
        remove_btn.clicked.connect(self.remove_education)
        btn_layout.addWidget(add_btn)
        btn_layout.addWidget(remove_btn)
        btn_layout.addStretch()
        layout.addLayout(btn_layout)
        
        # Manager Code, Responsibility and Special Requirements
        mc_layout = QHBoxLayout()
        self.mc_check = QCheckBox("Manager Code")
        self.mr_check = QCheckBox("Manager Responsibility")
        self.sr_check = QCheckBox("Special Requirements")
        mc_layout.addWidget(self.mc_check)
        mc_layout.addWidget(self.mr_check)
        mc_layout.addWidget(self.sr_check)
        mc_layout.addStretch()
        layout.addLayout(mc_layout)

        # Calculate Button and Result
        calc_layout = QHBoxLayout()
        calc_btn = QPushButton("Calculate Wage Level")
        calc_btn.clicked.connect(self.calculate_wage_level)
        self.result_label = QLabel("Wage Level: -")
        calc_layout.addWidget(calc_btn)
        calc_layout.addWidget(self.result_label)
        calc_layout.addStretch()
        layout.addLayout(calc_layout)

        layout.addStretch()

    def add_education(self):
        row = self.edu_table.rowCount()
        self.edu_table.insertRow(row)
        
        degree_combo = QComboBox()
        degree_combo.addItems(["bachelors", "masters", "phd"])
        
        years_spin = QSpinBox()
        years_spin.setRange(0, 20)
        
        self.edu_table.setCellWidget(row, 0, degree_combo)
        self.edu_table.setCellWidget(row, 1, years_spin)

    def remove_education(self):
        current_row = self.edu_table.currentRow()
        if current_row >= 0:
            self.edu_table.removeRow(current_row)

    def get_education_level(self, degree):
        levels = {'bachelors': 0, 'masters': 1, 'phd': 2}
        return levels.get(degree, -1)

    def get_z_value(self, z_table, years):
        table = Z4 if z_table == 'Z4' else Z5
        years = int(years)
        
        if z_table == 'Z4':
            if years > 4:
                return table['>4']
            return table.get(years, 0)
        else:  # Z5
            if years >= 11:
                return table['>=11']
            return table.get(years, 0)

    def calculate_wage_level(self):
        # Collect inputs
        Z = self.zone_combo.currentText()
        SR = self.sr_check.isChecked()
        MC = self.mc_check.isChecked()
        MR = self.mr_check.isChecked()
        IS = self.is_combo.currentText()

        # Collect education experience
        EE = {}
        for row in range(self.edu_table.rowCount()):
            degree = self.edu_table.cellWidget(row, 0).currentText()
            years = self.edu_table.cellWidget(row, 1).value()
            EE[degree] = years

        if not EE:
            QMessageBox.warning(self, "Error", "Please add at least one education entry.")
            return

        # Calculate wage level
        max_wl = 0
        
        # Get minimum education level
        min_edu_level = self.get_education_level(IS)
        
        # Calculate WL for each education experience
        for degree, years in EE.items():
            # Calculate education level difference
            current_edu_level = self.get_education_level(degree)
            edu_diff = current_edu_level - min_edu_level
            
            # Start with education difference
            wl = edu_diff
            
            # Add Z table value
            z_value = self.get_z_value(Z, years)
            wl += z_value
            
            # Keep track of highest WL
            max_wl = max(max_wl, wl)
        
        # Check manager conditions
        if not MC and MR:
            max_wl += 1
        
        # Add special requirements
        if SR :
            max_wl += 1
        
        # Cap at 4
        if max_wl <= 0:
            max_wl = 1
            
        final_wl = min(max_wl, 4)
        
        # Display result
        self.result_label.setText(f"Wage Level: {final_wl}")

def main():
    app = QApplication(sys.argv)
    calculator = WageCalculator()
    calculator.show()
    sys.exit(app.exec_())

if __name__ == '__main__':
    main()