﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ТекстОшибки = НСтр("ru = 'Отсутствует право сохранения данных. Обратитесь к администратору.'"); // Отказ устанавливается в ПриОткрытии.
		Возврат;
	КонецЕсли;
	
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	
	ПерсональныеНастройки = ЭлектроннаяПодпись.ПерсональныеНастройки();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПерсональныеНастройки);
	
	// Настройки видимости при запуске
	Элементы.ПараметрыВебКлиентаПодУправлениемLinux.Видимость = РежимРаботы.ЭтоВебКлиент И РежимРаботы.ЭтоLinuxКлиент;
	Элементы.ГруппаОбщаяФормаНастройкиЭП.Видимость            = РежимРаботы.ЭтоАдминистраторПрограммы;
	
	Если НЕ Параметры.Свойство("ПоказыватьНастройкиШифрования") Тогда
		Элементы.ЛичныйСертификатДляШифрования.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Если ОтпечатокЛичногоСертификатаДляШифрования <> Неопределено И НЕ ПустаяСтрока(ОтпечатокЛичногоСертификатаДляШифрования) Тогда
		Сертификат = ЭлектроннаяПодписьКлиент.ПолучитьСертификатПоОтпечатку(ОтпечатокЛичногоСертификатаДляШифрования, Истина); // ТолькоЛичные
		Если Сертификат = Неопределено Тогда
			ОтпечатокЛичногоСертификатаДляШифрования = "";
		Иначе
			СтруктураСертификата = ЭлектроннаяПодписьКлиент.ЗаполнитьСтруктуруСертификатаПоОтпечатку(ОтпечатокЛичногоСертификатаДляШифрования);
			ЛичныйСертификатДляШифрования = СтруктураСертификата.КомуВыдан;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ВыборСертификата") Тогда
		
		Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		
		ОтпечатокЛичногоСертификатаДляШифрования = ВыбранноеЗначение.Отпечаток;
		СтруктураСертификата = ЭлектроннаяПодписьКлиент.ЗаполнитьСтруктуруСертификатаПоОтпечатку(ОтпечатокЛичногоСертификатаДляШифрования);
		ЛичныйСертификатДляШифрования = СтруктураСертификата.КомуВыдан;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ЛичныйСертификатНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ПодключитьРасширениеРаботыСКриптографией() Тогда
		ВыбратьСертификатПослеУстановкиРасширения(Истина, Неопределено);
	Иначе
		Обработчик = Новый ОписаниеОповещения("ВыбратьСертификатПослеУстановкиРасширения", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Для выбора сертификата необходимо установить расширение работы с криптографией.'");
		ЭлектроннаяПодписьКлиент.УстановитьРасширение(Обработчик, ТекстВопроса);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛичныйСертификатОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ОтпечатокЛичногоСертификатаДляШифрования <> Неопределено И НЕ ПустаяСтрока(ОтпечатокЛичногоСертификатаДляШифрования) Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(ОтпечатокЛичногоСертификатаДляШифрования);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЛичныйСертификатОчистка(Элемент, СтандартнаяОбработка)
	ОтпечатокЛичногоСертификатаДляШифрования = "";
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	
	Если НЕ СохранитьНастройки() Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбщаяФормаНастройкиКриптографии(Команда)
	ОткрытьФорму("ОбщаяФорма.НастройкиКриптографии", , ЭтотОбъект);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция СохранитьНастройки()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПерсональныеНастройки = ЭлектроннаяПодпись.ПерсональныеНастройки(Истина);
	ЗаполнитьЗначенияСвойств(ПерсональныеНастройки, ЭтаФорма);
	ЭлектроннаяПодпись.СохранитьПерсональныеНастройки(ПерсональныеНастройки);
	
	Возврат Истина;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Служебные обработчики асинхронных диалогов

&НаКлиенте
Процедура ВыбратьСертификатПослеУстановкиРасширения(РасширениеУстановлено, ДополнительныеПараметры) Экспорт
	Если РасширениеУстановлено = Истина Тогда
		МассивСтруктурЛичныхСертификатов = ЭлектроннаяПодписьКлиент.ПолучитьМассивСтруктурСертификатов(Истина);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("МассивСтруктурСертификатов", МассивСтруктурЛичныхСертификатов);
		ОткрытьФорму("ОбщаяФорма.ПерсональныеСертификатыДляШифрования", ПараметрыФормы, ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры
