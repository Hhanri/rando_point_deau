enum Water {
  drinking,
  nonDrinkable;

  static Water defaultParse(String value) {
    return switch (value) {
      "drinking" => Water.drinking,
      "nonDrinkable" => Water.nonDrinkable,
      _ => Water.nonDrinkable,
    };
  }
}

typedef WaterEnumParser = Water Function(String);
