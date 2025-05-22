import 'package:flutter/material.dart';

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

  const RedeemPage({super.key, required this.userPoints});

  @override
  State<RedeemPage> createState() => _RedeemPageState();
}

class _RedeemPageState extends State<RedeemPage> {
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
          (context) => AlertDialog(
            title: Text(item.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  item.imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Text(item.description, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text(
                  'Points Required: ${item.pointsRequired}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your Points: ${widget.userPoints}',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        widget.userPoints >= item.pointsRequired
                            ? Colors.green
                            : Colors.red,
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
                onPressed:
                    widget.userPoints >= item.pointsRequired
                        ? () {
                          // Handle redemption
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
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Redeem'),
              ),
            ],
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
                'Points: ${widget.userPoints}',
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
          final canRedeem = widget.userPoints >= item.pointsRequired;

          return Card(
            elevation: 4,
            child: InkWell(
              onTap: () => _showRedeemDialog(item),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Image.asset(item.imagePath, fit: BoxFit.cover),
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
