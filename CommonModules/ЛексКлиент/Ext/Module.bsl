﻿Функция ПутьHTML (ИмяHTML) Экспорт
	
	ПутьHTML = "";
	
	ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
	РасширениеПодключено = ПодключитьРасширениеРаботыСФайлами();
	
	Если НЕ РасширениеПодключено Тогда
		
		ФайловыеФункцииСлужебныйКлиент.ПредупредитьОНеобходимостиРасширенияРаботыСФайлами();
		
	Иначе
		
		РабочийКаталог = ФайловыеФункцииСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя();
		ПутьHTML = РабочийКаталог + ИмяHTML;
		
		Файл = Новый Файл(ПутьHTML);
		
		Если НЕ Файл.Существует() Тогда
			ПутьHTML = "";
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ПутьHTML;
	
КонецФункции