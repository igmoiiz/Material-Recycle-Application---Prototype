import 'package:flutter/material.dart';
import 'package:recycle_application/Models/recycling_material.dart';

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
                    setState(() {
                      _totalPoints += points;
                    });
                    _amountController.clear();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added $points points!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
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
      appBar: AppBar(
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
