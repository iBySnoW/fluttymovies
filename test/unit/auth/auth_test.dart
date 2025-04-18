import 'package:flutter_test/flutter_test.dart';
import 'package:fluttymovies/features/auth/domain/entities/user.dart';

void main() {
  group('Auth Tests', () {
    test('User creation', () {
      final user = User(
        id: '123',
        name: 'Test User',
      );
      
      expect(user.id, '123');
      expect(user.name, 'Test User');
    });

    test('User creation without name', () {
      final user = User(
        id: '123',
      );
      
      expect(user.id, '123');
      expect(user.name, null);
    });

    test('Login validation', () {
      // Simuler une validation d'identifiant
      bool isValidId(String id) {
        return id.isNotEmpty && id.length >= 3;
      }
      
      expect(isValidId('123'), true);
      expect(isValidId(''), false);
      expect(isValidId('ab'), false);
    });
  });
} 