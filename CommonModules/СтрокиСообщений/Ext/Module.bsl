﻿
Функция АвансНедостаточен() Экспорт
	
	Возврат "Аванс %1 недостаточен. Для размещения документа требуется %2";
	
КонецФункции

// Возвращает примечание для печати Чертежа Двери
Функция ПримечаниеДвери() Экспорт
	
	Возврат "Размеры, указанные в эскизе могут отличаться от фактических по высоте до 3%,
	|по ширине до 5%. Размеры элементов дверей указываются от края двери (центра стыковочного профиля)
	|до центра стыковочного профиля (края двери). При использовании изогнутых стыковочных профилей
	|размеры их присоединения могут отличаться от фактических до 10%";
	
КонецФункции

Функция ФормСтрока() Экспорт
	
	Возврат "Л = ru_RU; ДП = Истина";
	
КонецФункции

Функция ПарПредмета() Экспорт
	
	Возврат "рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 0";
	
КонецФункции
