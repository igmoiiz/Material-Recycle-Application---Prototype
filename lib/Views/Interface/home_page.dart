import 'package:flutter/material.dart';
import 'package:recycle_application/Models/recycling_material.dart';
import 'package:recycle_application/Views/Authentication/loogin_page.dart';
import 'package:recycle_application/Views/Interface/redeem_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<RecyclingMaterial> _materials = RecyclingMaterial.getMaterials();
  String _selectedCategory = 'All';
  final TextEditingController _amountController = TextEditingController();
  int _totalPoints = 0;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _handleLogout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  void _showMaterialDialog(RecyclingMaterial material) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(material.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Points per kg: ${material.pointsPerKg}'),
                const SizedBox(height: 16),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount (kg)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_amountController.text.isNotEmpty) {
                    final amount = double.parse(_amountController.text);
                    final points = (amount * material.pointsPerKg).round();
                    _amountController.clear();
                    Navigator.pop(context);
                    _showDeliveryOptions(points, material.name, amount);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
    );
  }

  void _showDeliveryOptions(int points, String materialName, double amount) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Choose Delivery Option',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'You will earn $points points for $amount kg of $materialName',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Self Delivery Card
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _handleSelfDelivery(points);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.green),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.directions_walk,
                                size: 48,
                                color: Colors.green[700],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Self Delivery',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Drop at nearest center',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Rider Pickup Card
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _handlePickupRequest(points);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.delivery_dining,
                                size: 48,
                                color: Colors.blue[700],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Request Pickup',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'We\'ll collect from you',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.grey[800],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _handleSelfDelivery(int points) {
    setState(() {
      _totalPoints += points;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added $points points! Please deliver the material to our nearest collection center.',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
          textColor: Colors.white,
        ),
      ),
    );
  }

  void _handlePickupRequest(int points) {
    setState(() {
      _totalPoints += points;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added $points points! A rider will contact you shortly to schedule the pickup.',
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
          textColor: Colors.white,
        ),
      ),
    );
  }

  void _navigateToRedeem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RedeemPage(userPoints: _totalPoints),
      ),
    );
  }

  List<RecyclingMaterial> get _filteredMaterials {
    if (_selectedCategory == 'All') {
      return _materials;
    }
    return _materials.where((m) => m.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[600]),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.recycling, size: 64, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      'Trashure',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Recycle & Earn Rewards',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.card_giftcard),
              title: const Text('Redeem Points'),
              onTap: _navigateToRedeem,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: _handleLogout,
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: const Text('Recycle & Earn Points'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Points: $_totalPoints',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children:
                  ['All', ...RecyclingMaterial.getCategories()].map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          }
                        },
                      ),
                    );
                  }).toList(),
            ),
          ),

          // Materials Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _filteredMaterials.length,
              itemBuilder: (context, index) {
                final material = _filteredMaterials[index];
                return Card(
                  elevation: 4,
                  child: InkWell(
                    onTap: () => _showMaterialDialog(material),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getMaterialIcon(material.name),
                          size: 48,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          material.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${material.pointsPerKg} points/kg',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMaterialIcon(String materialName) {
    switch (materialName.toLowerCase()) {
      case 'paper':
        return Icons.article;
      case 'cardboard':
        return Icons.inventory_2;
      case 'plastic bottles':
        return Icons.local_drink;
      case 'glass bottles':
        return Icons.wine_bar;
      case 'aluminum cans':
        return Icons.local_cafe;
      case 'steel cans':
        return Icons.hardware;
      default:
        return Icons.recycling;
    }
  }
}
