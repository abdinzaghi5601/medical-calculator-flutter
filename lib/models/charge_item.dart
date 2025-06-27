class ChargeItem {
  final int chargeCode;
  final String chargeName;
  final String chargeCategory;
  final String chargeType;
  final String chargeGroup;
  final double baseRate;
  final Map<String, double> patientTypePrices;

  ChargeItem({
    required this.chargeCode,
    required this.chargeName,
    required this.chargeCategory,
    required this.chargeType,
    required this.chargeGroup,
    required this.baseRate,
    required this.patientTypePrices,
  });

  factory ChargeItem.fromCsvRow(List<String> row) {
    if (row.length < 17) {
      throw ArgumentError('Invalid CSV row: insufficient columns');
    }

    return ChargeItem(
      chargeType: row[0].trim(),
      chargeGroup: row[1].trim(),
      chargeCategory: row[2].trim(),
      chargeCode: int.parse(row[3].trim()),
      chargeName: row[4].trim(),
      baseRate: double.parse(row[5].trim()),
      patientTypePrices: {
        'local': double.parse(row[6].trim()),
        'gcc': double.parse(row[7].trim()),
        'resident': double.parse(row[8].trim()),
        'shc_gcc': double.parse(row[9].trim()),
        'rhc_gcc': double.parse(row[10].trim()),
        'shc': double.parse(row[11].trim()),
        'rhc': double.parse(row[12].trim()),
        'visitor': double.parse(row[13].trim()),
        'servant': double.parse(row[14].trim()),
        'handicap': double.parse(row[15].trim()),
        'baby': double.parse(row[16].trim()),
      },
    );
  }

  double getPriceForPatientType(String patientType) {
    return patientTypePrices[patientType] ?? 0.0;
  }
}