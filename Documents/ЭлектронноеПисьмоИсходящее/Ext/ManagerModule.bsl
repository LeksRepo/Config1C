﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьКонтакты(Ссылка) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Адрес,
	|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Представление,
	|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Контакт
	|ИЗ
	|	Документ.ЭлектронноеПисьмоИсходящее.ПолучателиПисьма КАК ЭлектронноеПисьмоИсходящееПолучателиПисьма
	|ГДЕ
	|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Адрес,
	|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Представление,
	|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Контакт
	|ИЗ
	|	Документ.ЭлектронноеПисьмоИсходящее.ПолучателиКопий КАК ЭлектронноеПисьмоИсходящееПолучателиКопий
	|ГДЕ
	|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЭлектронноеПисьмоИсходящееПолучателиОтвета.Адрес,
	|	ЭлектронноеПисьмоИсходящееПолучателиОтвета.Представление,
	|	ЭлектронноеПисьмоИсходящееПолучателиОтвета.Контакт
	|ИЗ
	|	Документ.ЭлектронноеПисьмоИсходящее.ПолучателиОтвета КАК ЭлектронноеПисьмоИсходящееПолучателиОтвета
	|ГДЕ
	|	ЭлектронноеПисьмоИсходящееПолучателиОтвета.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Адрес,
	|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Представление,
	|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Контакт
	|ИЗ
	|	Документ.ЭлектронноеПисьмоИсходящее.ПолучателиСкрытыхКопий КАК ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий
	|ГДЕ
	|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Ссылка = &Ссылка";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	ТабЗн = Запрос.Выполнить().Выгрузить();
	
	Возврат Взаимодействия.ПреобразоватьТаблицуКонтактовВМассив(ТабЗн);
	
КонецФункции

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ВзаимодействияВызовСервера.ОбработкаПолученияДанныхВыбора(
		ДанныеВыбора,
		Параметры,
		СтандартнаяОбработка, 
		"ЭлектронноеПисьмоИсходящее");
	
КонецПроцедуры
