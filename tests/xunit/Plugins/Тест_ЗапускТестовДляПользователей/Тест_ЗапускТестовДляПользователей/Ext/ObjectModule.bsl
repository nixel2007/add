﻿Перем КонтекстЯдра;
Перем Утверждения;
Перем МенеджерЗапуска1С;

//{ основная процедура для юнит-тестирования xUnitFor1C
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	МенеджерЗапуска1С = КонтекстЯдра.Плагин("ЗапускТестовДляПользователей");
КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
	НаборТестов.Добавить("ТестДолжен_ЗапуститьПользователя");
КонецПроцедуры

//}

//{ Блок юнит-тестов

Процедура ПередЗапускомТеста() Экспорт
	НачатьТранзакцию();
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	Если ТранзакцияАктивна() Тогда
	    ОтменитьТранзакцию();
	КонецЕсли;
КонецПроцедуры

Процедура ТестДолжен_ЗапуститьПользователя() Экспорт
	ТипКлиента = МенеджерЗапуска1С.ВозможныеТипыКлиентов().ТолстыйОФ;
	ОписаниеПользователя = Новый Структура("Логин,Пароль", "User", "");
	ПутьТестов = МенеджерЗапуска1С.КаталогЗапускателяТестов() + "/tests/xunit/plugins/Тесты_СтроковыеУтилиты.epf";
	
	ОписаниеРезультата = МенеджерЗапуска1С.ЗапуститьТестДляПользователя(ОписаниеПользователя, ПутьТестов, ТипКлиента);
	КодВозврата = ОписаниеРезультата.КодВозврата;
	ПутьОтчетаJUnit = ОписаниеРезультата.ПутьОтчетаJUnit;
	ПутьЛогФайла = ОписаниеРезультата.ПутьЛогФайла;
	
	Утверждения.ПроверитьРавенство(КодВозврата, 0, "КодВозврата");
	
	Утверждения.ПроверитьЗаполненность(ПутьОтчетаJUnit, 0, "ПутьОтчетаJUnit");
	Файл = Новый Файл(ПутьОтчетаJUnit);
	Утверждения.ПроверитьИстину(Файл.Существует(), "Файл не существует - ПутьОтчетаJUnit: " + Файл.ПолноеИмя);
	
	Файл = Новый Файл(ПутьЛогФайла);
	Утверждения.ПроверитьИстину(Файл.Существует(), "Файл не существует - ПутьЛогФайла: " + Файл.ПолноеИмя);
	Утверждения.ПроверитьЗаполненность(ПутьЛогФайла, 0, "ПутьЛогФайла");
КонецПроцедуры

//}