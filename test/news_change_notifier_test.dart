import 'package:flutter_test/flutter_test.dart';
import 'package:testing_flutter_app/article.dart';

import 'package:testing_flutter_app/news_change_notifier.dart';
import 'package:testing_flutter_app/news_service.dart';

import 'package:mocktail/mocktail.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut;
  late MockNewsService mockNewsService;
  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test(
    "Check if initial values are correct",
    () {
      expect(sut.articles, []);
      expect(sut.isLoading, false);
    },
  );
  group("getArticles", () {
    final articlesFromService = [
      Article(title: "Test 1 ", content: "Test one content"),
      Article(title: "Test 2 ", content: "Test two content"),
      Article(title: "Test 3 ", content: "Test three content"),
    ];
    void arrangingNewsServiceReturns3Articles() {
      when(() => mockNewsService.getArticles()).thenAnswer(
        (_) async => articlesFromService,
      );
    }

    test("gets articles using news servicr", () async {
      arrangingNewsServiceReturns3Articles();
      await sut.getArticles();
      verify(() => mockNewsService.getArticles()).called(1);
    });

    test("""Data is in loading state,
   set articles got from service,
    Data is not beiging loaded anymore""", () async {
      arrangingNewsServiceReturns3Articles();
      final future = sut.getArticles();
      expect(sut.isLoading, true);
      await future;
      expect(sut.articles, articlesFromService);
      expect(sut.isLoading, false);
    });
  });
}
