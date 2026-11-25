import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/project.dart';

void main() {
  group('Project', () {
    test('fromJson membaca kunci snake_case dari DRF', () {
      final project = Project.fromJson(<String, dynamic>{
        'id': '8f14e45f-ceea-4e7a-9f1b-123456789abc',
        'title': 'MyPortfolio',
        'description': 'Website portofolio pribadi',
        'tech_stack': 'Django, Flutter',
        'project_url': 'https://example.com',
        'project_image_url': null,
      });

      expect(project.id, '8f14e45f-ceea-4e7a-9f1b-123456789abc');
      expect(project.techStack, 'Django, Flutter');
      expect(project.projectUrl, 'https://example.com');
      expect(project.projectImageUrl, '');
    });

    test('toJson tidak menyertakan id', () {
      const project = Project(
        id: 'abc',
        title: 'MyPortfolio',
        description: 'Website portofolio pribadi',
        techStack: 'Django, Flutter',
        projectUrl: 'https://example.com',
      );

      final json = project.toJson();

      expect(json.containsKey('id'), isFalse);
      expect(json['tech_stack'], 'Django, Flutter');
      expect(json['project_image_url'], '');
    });
  });
}
