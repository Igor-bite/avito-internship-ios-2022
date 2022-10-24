# Тестовое задание на позицию стажёра в iOS, 2022 год 

[![CI](https://github.com/Igor-bite/avito-internship-ios-2022/actions/workflows/build_and_test_all.yaml/badge.svg?branch=develop)](https://github.com/Igor-bite/avito-internship-ios-2022/actions/workflows/build_and_test_all.yaml)

## Общее описание задания
Написать приложение для iOS. Приложение должно состоять из одного экрана со списком. Список данных в формате JSON приложение загружает из интернета по [ссылке](https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c), необходимо распарсить эти данные и отобразить их в списке. 

## Что было сделано

### Devtools
* SwiftGen для шрифтов и изображений
* SwiftFormat (pre-commit git hook)
* swiftlint (build phase)
* GitHub actions + fastlane

### Характеристики приложения:
* iOS 13+
* Поддержка iPhone и iPad
* GitFlow
* Светлая + тёмная темы
* UICollectionViewDiffableDatasource + CompositionalFlowLayout
* VIPER (without router as there is no routing)

### Фичи
* Виброотдача для алертов
* Мониторинг подключения к интернету
* Динамическое отображение иконки отсутвия интернета
* Логирование ошибок и ивентов
* При нажатии на номер сотрудника - action sheet с возможностью позвонить по номеру
* Сетевые запросы на URLSession
* Кэширование запроса на 1 час
* SwipeToRefresh с принудительным обновлением данных при наличие интернета
* Unit Тесты
* UI тесты (snapshot проверка)
* Выгрузка логов тестов в github actions artefacts при проваленном тестировании
* Поддержка вертикальной и горизонтальной ориентации

### Скриншоты
#### - iPhone
![](Screenshots/iphones.png)
#### - Landscape
![](Screenshots/iPhone_14_Pro-landscape.png)
#### - iPad
![](Screenshots/ipads.png)

---
<details>
<summary>Требования по выполнению:</summary>

### Требование к реализации:
- Приложение работает на iOS 13 и выше
- Реализована поддержка iPhone и iPad
- Список отсортирован по алфавиту
- Кэширование ответа на 1 час
- Обработаны случаи потери сети / отсутствия соединения

Внешний вид приложения: по возможности, лаконичный, но, в целом, на усмотрение кандидата.

### Требования к коду:
 - Приложение написано на языке Swift
 - Пользовательский интерфейс приложения настроен в InterfaceBuilder (в Storiboard или Xib файлы) или кодом без использования SwiftUI
 - Для отображения списка используется UITableView, либо UICollectionView
 - Для запроса данных используется URLSession

### Требования к передаче результатов:
- Код должен быть выложен в git-репозиторий на [github.com](http://github.com/) и отправлен нам.

</details>

---

<details>
<summary>Пример данных API:</summary>

```json
{
    "company": {
        "name":"Avito",
        "employees": [
            {
                "name": "John",
                "phone_number": "769453",
                "skills": ["Swift", "iOS"]
            }, 
            {
                "name": "Diego",
                "phone_number": "987924",
                "skills": ["Kotlin", "Android"]
            }, 
            {
                "name": "Alfred",
                "phone_number": "452533",
                "skills": ["Objective-C", "Android", "Photoshop"]
            }, 
            {
                "name": "John",
                "phone_number": "212456",
                "skills": ["Java", "Python"]
            }, 
            {
                "name": "Mat",
                "phone_number": "778975",
                "skills": ["Android", "MovieMaker"]
            }, 
            {
                "name": "Bob",
                "phone_number": "456468",
                "skills": ["Groovy", "Kotlin"]
            }, 
            {
                "name": "Marty",
                "phone_number": "321789",
                "skills": ["Android", "PHP", "C#"]
            }
        ]	
    }
}
```

</details>

---