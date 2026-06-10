import 'package:flutter/material.dart';
import '../../domain/models/monster_model.dart';

class MonsterDictionaryScreen extends StatelessWidget {
  const MonsterDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final monsters = MonsterDictionary.allMonsters;

    return Scaffold(
      appBar: AppBar(
        title: const Text('몬스터 도감'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: monsters.length,
        itemBuilder: (context, index) {
          final monster = monsters[index];
          return Card(
            color: const Color(0xFF2D2D44),
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      monster.imagePath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[800],
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          monster.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          monster.englishName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: monster.difficulty == '쉬움'
                                    ? Colors.green
                                    : monster.difficulty == '보통'
                                        ? Colors.orange
                                        : Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                monster.difficulty,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('HP: ${monster.maxHp}', style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          monster.description,
                          style: const TextStyle(color: Colors.white70, height: 1.4),
                        ),
                      ],
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
