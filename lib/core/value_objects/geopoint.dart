import 'package:equatable/equatable.dart';

base class GeoPoint extends Equatable {

  final double lat;
  final double lng;

  const GeoPoint({required this.lat, required this.lng});

  Map<String, dynamic> toJson() {
    return {
      "lat": lat,
      "lng": lng,
    };
  }

  @override
  List<Object?> get props => [
    lat,
    lng,
  ];

}