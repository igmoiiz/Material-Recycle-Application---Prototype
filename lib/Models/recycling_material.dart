class RecyclingMaterial {
  final String name;
  final String category;
  final int pointsPerKg;
  final String imageUrl;

  RecyclingMaterial({
    required this.name,
    required this.category,
    required this.pointsPerKg,
    required this.imageUrl,
  });

  static List<RecyclingMaterial> getMaterials() {
    return [
      RecyclingMaterial(
        name: 'Paper',
        category: 'Paper & Cardboard',
        pointsPerKg: 300,
        imageUrl: 'assets/images/paper.png',
      ),
      RecyclingMaterial(
        name: 'Cardboard',
        category: 'Paper & Cardboard',
        pointsPerKg: 250,
        imageUrl: 'assets/images/cardboard.png',
      ),
      RecyclingMaterial(
        name: 'Plastic Bottles',
        category: 'Plastic',
        pointsPerKg: 400,
        imageUrl: 'assets/images/plastic_bottles.png',
      ),
      RecyclingMaterial(
        name: 'Glass Bottles',
        category: 'Glass',
        pointsPerKg: 350,
        imageUrl: 'assets/images/glass_bottles.png',
      ),
      RecyclingMaterial(
        name: 'Aluminum Cans',
        category: 'Metal',
        pointsPerKg: 500,
        imageUrl: 'assets/images/aluminum_cans.png',
      ),
      RecyclingMaterial(
        name: 'Steel Cans',
        category: 'Metal',
        pointsPerKg: 450,
        imageUrl: 'assets/images/steel_cans.png',
      ),
    ];
  }

  static List<String> getCategories() {
    return ['Paper & Cardboard', 'Plastic', 'Glass', 'Metal'];
  }
}
