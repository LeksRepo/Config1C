﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Печать".
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает описание команды по имени элемента формы.
// 
// См. УправлениеПечатью.ОписаниеКомандыПечати
//
Функция ОписаниеКомандыПечати(ИмяКоманды, ИмяФормы) Экспорт
	
	Возврат УправлениеПечатьюВызовСервера.ОписаниеКомандыПечати(ИмяКоманды, ИмяФормы);
	
КонецФункции
