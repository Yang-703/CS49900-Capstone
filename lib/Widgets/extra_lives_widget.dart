/* lib/Widgets/extra_life_widget.dart */
import 'package:flutter/material.dart';
import 'package:flutter_study_app/Service/shop_service.dart';

class ExtraLivesWidget extends StatelessWidget {
  const ExtraLivesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ShopService shopService = ShopService();
    return StreamBuilder<int>(
      stream: shopService.extraLivesStream(),
      builder: (context, snap) {
        final lives = snap.data ?? 0;
        if (lives <= 0) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color.fromARGB(255, 252, 154, 152), Color.fromARGB(255, 236, 87, 41)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.orange,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite, size: 30, color: Colors.red),
              const SizedBox(width: 12),
              Text(
                'Extra Lives: $lives',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black26,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}