enum Water {
  drinking,
  nonDrinking;

  static Water defaultParse(String value) {
    return switch(value) {
      "drinking" => Water.drinking,
      "nonDrinking" => Water.nonDrinking,
      _ => Water.nonDrinking,
    };
  }
}

typedef WaterEnumParser = Water Function(String);