class PatientTypes {
  static const List<String> types = [
    'local',
    'gcc',
    'resident',
    'shc_gcc',
    'rhc_gcc',
    'shc',
    'rhc',
    'visitor',
    'servant',
    'handicap',
    'baby',
  ];

  static String getDisplayName(String type) {
    switch (type) {
      case 'local':
        return 'Local';
      case 'gcc':
        return 'GCC';
      case 'resident':
        return 'Resident';
      case 'shc_gcc':
        return 'SHC-GCC';
      case 'rhc_gcc':
        return 'RHC-GCC';
      case 'shc':
        return 'SHC';
      case 'rhc':
        return 'RHC';
      case 'visitor':
        return 'Visitor';
      case 'servant':
        return 'Servant';
      case 'handicap':
        return 'Handicap';
      case 'baby':
        return 'Baby';
      default:
        return type.replaceAll('_', '-').toUpperCase();
    }
  }
}