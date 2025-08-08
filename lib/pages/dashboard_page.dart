import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardItems = [
      {
        'title': 'Total Revenue',
        'icon': Icons.attach_money,
        'value': '₹1,25,000',
        'trend': 'up',
        'color': Colors.green,
      },
      {
        'title': 'Pending Collections',
        'icon': Icons.pending_actions,
        'value': '₹50,000',
        'trend': 'down',
        'color': Colors.red,
      },
      {
        'title': "Active MR's",
        'icon': Icons.people_alt,
        'value': '12',
        'trend': 'up',
        'color': Colors.green,
      },
      {
        'title': 'Team Expense',
        'icon': Icons.receipt_long,
        'value': '₹30,000',
        'trend': 'neutral',
        'color': Colors.orange,
      },
      {
        'title': 'New Leads',
        'icon': Icons.leaderboard,
        'value': '25',
        'trend': 'up',
        'color': Colors.green,
      },
      {
        'title': 'Customer Satisfaction',
        'icon': Icons.sentiment_satisfied_alt,
        'value': '85%',
        'trend': 'up',
        'color': Colors.green,
      },
      {
        'title': 'Sales Overview',
        'icon': Icons.show_chart,
        'value': '↑ 12% from last month',
        'trend': 'up',
        'color': Colors.green,
      },
      {
        'title': 'Top performing MRs',
        'icon': Icons.emoji_events,
        'value': 'Rahul, Priya',
        'trend': 'neutral',
        'color': Colors.blue,
      },
    ];

    IconData getTrendIcon(String? trend) {
      switch (trend) {
        case 'up':
          return Icons.arrow_upward;
        case 'down':
          return Icons.arrow_downward;
        default:
          return Icons.trending_flat;
      }
    }

    Color getTrendColor(String? trend, Color color) {
      switch (trend) {
        case 'up':
        case 'down':
          return color;
        default:
          return Colors.grey;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GridView.builder(
        itemCount: dashboardItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.3,
        ),
        itemBuilder: (context, index) {
          final item = dashboardItems[index];
          final trend = item['trend'] as String?;
          final color = item['color'] as Color;
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.12),
                    radius: 16,
                    child: Icon(
                      item['icon'] as IconData,
                      size: 18,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['title'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        getTrendIcon(trend),
                        color: getTrendColor(trend, color),
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          item['value'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: getTrendColor(trend, color),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
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
