/// Free Wikimedia fallbacks when bundled JPGs are absent.
const karachiBackgroundUrls = <String, String>{
  'assets/backgrounds/karachi_clifton_sunset.jpg':
      'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Seaview_%28Clifton_Beach%29_Karachi.jpg/1280px-Seaview_%28Clifton_Beach%29_Karachi.jpg',
  'assets/backgrounds/karachi_food_street.jpg':
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Food_street%2C_Burns_Road%2C_Karachi.jpg/1280px-Food_street%2C_Burns_Road%2C_Karachi.jpg',
  'assets/backgrounds/karachi_seafront_evening.jpg':
      'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8e/Port_Grand_Food_and_Entertainment_Complex.jpg/1280px-Port_Grand_Food_and_Entertainment_Complex.jpg',
  'assets/backgrounds/karachi_coast_aerial.jpg':
      'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Seaview_%28Clifton_Beach%29_Karachi.jpg/1280px-Seaview_%28Clifton_Beach%29_Karachi.jpg',
  'assets/backgrounds/paper_texture.jpg':
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Food_street%2C_Burns_Road%2C_Karachi.jpg/640px-Food_street%2C_Burns_Road%2C_Karachi.jpg',
};

String karachiBackgroundUrl(String assetPath) =>
    karachiBackgroundUrls[assetPath] ?? karachiBackgroundUrls.values.first;
