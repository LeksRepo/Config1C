﻿
&НаКлиенте
Процедура Добавить(Команда)
	
	ИмяФайла = "";
	Если ПоместитьФайл(АдресВХранилище, , ИмяФайла, , УникальныйИдентификатор) Тогда
		Файл = Новый Файл(ИмяФайла);
		Объект.ИмяФайла = Файл.Имя;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	РегистрыСведений.ФайлыВБазе.ЗаписатьФайлВРегистр(ТекущийОбъект.Ссылка, АдресВХранилище);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Структура = РегистрыСведений.ФайлыВБазе.ПолучитьСвойстваФайла(Объект.Ссылка, УникальныйИдентификатор);
		
		АдресВХранилище = Структура.АдресВХранилище;
		РазмерФайла = Структура.Размер;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если ЭтоАдресВременногоХранилища(АдресВХранилище) Тогда
			ПолучитьФайл(АдресВХранилище, Объект.ИмяФайла);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ДоступноРедактированиеФайла() Тогда
		
		Если ЗначениеЗаполнено(Объект.Ссылка)
			И ЭтоАдресВременногоХранилища(АдресВХранилище) Тогда
			Отказ = Истина;
			ПолучитьФайл(АдресВХранилище, Объект.ИмяФайла);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДоступноРедактированиеФайла()
	
	Возврат РольДоступна("ПолныеПрава") ИЛИ РольДоступна("ДобавлениеИзменениеУчебныхЗанятий");
	
КонецФункции
