class PlaceModel {
  final String addres;
  final double lat;
  final double lng;

  PlaceModel({
    required this.addres,
    required this.lat,
    required this.lng,
  });

  @override
  String toString() => 'PlaceModel(addres: $addres, lat: $lat, lng: $lng)';
}
