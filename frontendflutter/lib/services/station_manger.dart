class StationManager {
  static final StationManager _instance = StationManager._internal();
  List<Map<String, dynamic>> _allStations = [];

  factory StationManager() {
    return _instance;
  }

  StationManager._internal();

  List<Map<String, dynamic>> get allStations => _allStations;

  void setAllStations(List<Map<String, dynamic>> stations) {
    _allStations = stations;
  }
}
