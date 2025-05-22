import 'package:flutter/material.dart';
import 'package:recycle_application/Controllers/database_helper.dart';

class RedeemItem {
  final String name;
  final String imagePath;
  final int pointsRequired;
  final String description;

  RedeemItem({
    required this.name,
    required this.imagePath,
    required this.pointsRequired,
    required this.description,
  });
}

class RedeemPage extends StatefulWidget {
  final int userPoints;
  final Function(int) onPointsDeducted;
  final String userEmail;

  const RedeemPage({
    super.key,
    required this.userPoints,
    required this.onPointsDeducted,
    required this.userEmail,
  });

  @override
  State<RedeemPage> createState() => _RedeemPageState();
}

class _RedeemPageState extends State<RedeemPage> {
  late int _currentPoints;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _currentPoints = widget.userPoints;
  }

  Future<void> _handleRedeem(RedeemItem item) async {
    if (_currentPoints >= item.pointsRequired) {
      final newPoints = _currentPoints - item.pointsRequired;
      await _databaseHelper.updateUserPoints(widget.userEmail, newPoints);
      setState(() {
        _currentPoints = newPoints;
      });
      widget.onPointsDeducted(item.pointsRequired);
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully redeemed ${item.name}! Points deducted: ${item.pointsRequired}',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  final List<RedeemItem> _redeemItems = [
    RedeemItem(
      name: 'Burger',
      imagePath: 'assets/images/burger.jpeg',
      pointsRequired: 4000,
      description: 'Delicious beef burger with fresh vegetables',
    ),
    RedeemItem(
      name: 'Pizza',
      imagePath: 'assets/images/pizza.jpeg',
      pointsRequired: 5000,
      description: 'Classic margherita pizza with extra cheese',
    ),
    RedeemItem(
      name: 'Croissant',
      imagePath: 'assets/images/croissant.jpeg',
      pointsRequired: 2000,
      description: 'Buttery and flaky French pastry',
    ),
    RedeemItem(
      name: 'Sandwich',
      imagePath: 'assets/images/sandwich.jpeg',
      pointsRequired: 3000,
      description: 'Fresh club sandwich with premium ingredients',
    ),
  ];

  void _showRedeemDialog(RedeemItem item) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      item.imagePath,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 64,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Points Required:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${item.pointsRequired}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          _currentPoints >= item.pointsRequired
                              ? Colors.green[50]
                              : Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your Points:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$_currentPoints',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                _currentPoints >= item.pointsRequired
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed:
                            _currentPoints >= item.pointsRequired
                                ? () => _handleRedeem(item)
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Redeem'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redeem Points'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Points: $_currentPoints',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _redeemItems.length,
        itemBuilder: (context, index) {
          final item = _redeemItems[index];
          final canRedeem = _currentPoints >= item.pointsRequired;

          return Card(
            elevation: 4,
            child: InkWell(
              onTap: () => _showRedeemDialog(item),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                      child: Image.asset(
                        item.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item.pointsRequired} points',
                            style: TextStyle(
                              fontSize: 16,
                              color: canRedeem ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
