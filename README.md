# E-Commerce API Client с использованием Retrofit

Этот проект демонстрирует использование библиотеки **Retrofit** во Flutter для работы с REST API. Мы создали простое приложение для отображения товаров из интернет-магазина и их фильтрации по категориям. Ниже приведено описание ключевых возможностей Retrofit, которые мы использовали, и примеры кода.

---

## **Основные возможности Retrofit**

### 1. **Автоматическая генерация кода**
Retrofit использует аннотации для описания API-запросов, а затем генерирует код для выполнения этих запросов. Это значительно упрощает работу с API и уменьшает количество ручного кода.

#### Пример аннотаций:
```dart
@GET('/products')
Future<List<Product>> getProducts();
```
2. Типобезопасность
Retrofit обеспечивает типобезопасность, что позволяет избежать ошибок, связанных с неправильным использованием данных. Все ответы автоматически парсятся в указанные типы данных.

Пример:
```dart
@GET('/products/{id}')
Future<Product> getProduct(@Path('id') int id);
```
3. Поддержка различных типов запросов
Retrofit поддерживает все основные HTTP-методы (GET, POST, PUT, DELETE и т.д.), а также позволяет передавать параметры запроса, заголовки и тело запроса.

Пример POST-запроса:
```dart
@POST('/products')
Future<Product> createProduct(@Body() Product product);
```
4. Интеграция с dio
Retrofit построен на основе dio, что позволяет использовать все возможности dio, такие как перехватчики (interceptors), отмена запросов и кэширование.


5. Поддержка JSON-парсинга
Retrofit интегрируется с библиотеками для JSON-парсинга, такими как json_serializable, что упрощает преобразование JSON-ответов в объекты Dart.

---

## Описание проекта
### Функции приложения
- Отображение товаров:
  - Приложение отображает список товаров, полученных с API. 
  - Для каждого товара отображается название, цена, описание и изображение.

- Фильтрация по категориям:
  - Пользователь может выбрать категорию из выпадающего списка. 
  - Приложение отображает только товары из выбранной категории.

- Обработка ошибок:
  - Приложение обрабатывает ошибки сети и API, выводя соответствующие сообщения.

---

### Используемые технологии
- Retrofit: Для выполнения HTTP-запросов и работы с API.
- Dio: Как HTTP-клиент, на котором построен Retrofit.
- Fake Store API: Для получения данных о товарах и категориях.

---

### Пример кода
#### Определение API-интерфейса
```dart
@RestApi(baseUrl: "https://fakestoreapi.com/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('/products')
  Future<List<Product>> getProducts();

  @GET('/products/categories')
  Future<List<String>> getCategories();

  @GET('/products/category/{category}')
  Future<List<Product>> getProductsByCategory(@Path('category') String category);
}
```

#### Модель данных
```dart
@JsonSerializable()
class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
```

#### Использование API в UI
```dart
Future<void> _loadProducts() async {
  try {
    final products = await _apiService.getProducts();
    setState(() {
      _products = products;
    });
  } catch (e) {
    print('Ошибка загрузки товаров: $e');
  }
}
```

---


## Заключение
Этот проект демонстрирует основные возможности библиотеки Retrofit:
- Автоматическая генерация кода: Использование аннотаций для описания API-запросов.
- Типобезопасность: Парсинг JSON-ответов в объекты Dart.
- Фильтрация и UI-интеграция: Отображение и фильтрация товаров по категориям.

Retrofit — это мощный инструмент для работы с REST API, который значительно упрощает разработку и обеспечивает типобезопасность.
