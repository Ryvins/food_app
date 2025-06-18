import 'package:flutter/material.dart';

/// Widget untuk menampilkan tab kategori dengan ikon di samping teks
Widget categoryTabWithIcon(String title, String iconPath, bool isActive) {
  return Container(
    height: 40, // tinggi fix
    margin: const EdgeInsets.only(right: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: isActive ? Color(0xFF2FA8FF) : Colors.white,
      border: isActive
          ? null
          : Border.all(color: Colors.grey.shade300, width: 1),
      borderRadius: BorderRadius.circular(20),
    ),
    alignment: Alignment.center,
    child: Row(
      children: [
        Image.asset(iconPath, height: 20, width: 20),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : Colors.black87,
          ),
        ),
      ],
    ),
  );
}

class CategoryTabs extends StatelessWidget {
  const CategoryTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        categoryTabWithIcon('Telur', 'assets/images/icon_telur.jpg', true),
        categoryTabWithIcon('Botok', 'assets/images/icon_botok.jpg', false),
        categoryTabWithIcon('Kerupuk', 'assets/images/icon_kerupuk.jpg', false),
        categoryTabWithIcon('Jus', 'assets/images/icon_jus.jpg', false),
      ],
    );
  }
}
