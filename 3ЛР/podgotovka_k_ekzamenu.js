// БД: podgotovka_k_ekzamenu — порядок подготовки к экзамену, предполагающий получение отличной оценки
// MongoDB 4.4+
// ЛР3 — документная модель, разработанная на основе реляционной БД из ЛР1 (схема podgotovka_k_ekzamenu, 3NF)

use podgotovka_k_ekzamenu

// =====================================================================
// 1. KATEGORIYA_EKZEMANA — категории экзаменов (предметы)
// =====================================================================
db.kategoriya_ekzamena.insertMany([
  { _id: 1, kod: "MATH", nazvanie: "Математика", min_uroven: 3, opisanie: "Подготовка к экзамену по математике на оценку «отлично»" },
  { _id: 2, kod: "RUS",  nazvanie: "Русский язык", min_uroven: 3, opisanie: "Подготовка к экзамену по русскому языку на оценку «отлично»" },
  { _id: 3, kod: "INF",  nazvanie: "Информатика", min_uroven: 2, opisanie: "Подготовка к экзамену по информатике на оценку «отлично»" },
  { _id: 4, kod: "PHYS", nazvanie: "Физика", min_uroven: 3, opisanie: "Подготовка к экзамену по физике на оценку «отлично»" },
  { _id: 5, kod: "ANG",  nazvanie: "Английский язык", min_uroven: 2, opisanie: "Подготовка к экзамену по английскому языку на оценку «отлично»" }
])

// =====================================================================
// 2. TIP_MATERIALA — виды учебных материалов
// =====================================================================
db.tip_materiala.insertMany([
  { _id: 1, nazvanie: "Учебник" },
  { _id: 2, nazvanie: "Конспект лекций" },
  { _id: 3, nazvanie: "Тестовые задания" },
  { _id: 4, nazvanie: "Видеолекции" },
  { _id: 5, nazvanie: "Тренажёры" },
  { _id: 6, nazvanie: "Шпаргалки/формулы" },
  { _id: 7, nazvanie: "Рекомендуемая литература" },
  { _id: 8, nazvanie: "Разбор типовых ошибок" },
  { _id: 9, nazvanie: "Пробные экзамены" },
  { _id: 10, nazvanie: "Мнемонические таблицы" }
])

// =====================================================================
// 3. STATUS_PLANA — статусы плана подготовки
// =====================================================================
db.status_plana.insertMany([
  { _id: 1, nazvanie: "Создан" },
  { _id: 2, nazvanie: "В процессе" },
  { _id: 3, nazvanie: "Завершён" },
  { _id: 4, nazvanie: "Отлично (все этапы на 5)" },
  { _id: 5, nazvanie: "Приостановлен" },
  { _id: 6, nazvanie: "Отменён" }
])

// =====================================================================
// 4. SPOSOB_OPLATY — способы оплаты
// =====================================================================
db.sposob_oplaty.insertMany([
  { _id: 1, nazvanie: "Наличные" },
  { _id: 2, nazvanie: "Банковская карта" },
  { _id: 3, nazvanie: "СБП" },
  { _id: 4, nazvanie: "Онлайн-перевод" },
  { _id: 5, nazvanie: "QR-код" },
  { _id: 6, nazvanie: "Безналичный расчёт" },
  { _id: 7, nazvanie: "Госуслуги" },
  { _id: 8, nazvanie: "Рассрочка" }
])

// =====================================================================
// 5. DOLZHNOST — должности преподавателей/персонала
// =====================================================================
db.dolzhnost.insertMany([
  { _id: 1, nazvanie: "Преподаватель предмета" },
  { _id: 2, nazvanie: "Методист" },
  { _id: 3, nazvanie: "Тьютор/куратор" },
  { _id: 4, nazvanie: "Экзаменатор" },
  { _id: 5, nazvanie: "Руководитель образовательного центра" },
  { _id: 6, nazvanie: "Администратор" }
])

// =====================================================================
// 6. ETAP_PODGOTOVKI — этапы подготовки с критериями «отлично»
// =====================================================================
db.etap_podgotovki.insertMany([
  {
    _id: 1, kategoriya_id: 1, nomer_shaga: 1,
    nazvanie: "Регистрация и знакомство с программой",
    opisanie: "Ознакомление с экзаменационной программой, распределением тем и критериями оценивания.",
    organizatsiya: "Методист", obyazatelnyy: true, srok_dney: 2,
    kriterii_otlichno: "Изучены все разделы программы, отмечены слабые и сильные темы",
    materialy: [
      { tip_materiala_id: 1, obyazatelnyy: true },
      { tip_materiala_id: 7, obyazatelnyy: false }
    ]
  },
  {
    _id: 2, kategoriya_id: 1, nomer_shaga: 2,
    nazvanie: "Диагностическое тестирование",
    opisanie: "Входное тестирование для определения текущего уровня знаний и пробелов.",
    organizatsiya: "Преподаватель предмета", obyazatelnyy: true, srok_dney: 1,
    kriterii_otlichno: "Пройден диагностический тест, составлен индивидуальный план устранения пробелов",
    materialy: [
      { tip_materiala_id: 3, obyazatelnyy: true },
      { tip_materiala_id: 9, obyazatelnyy: false }
    ]
  },
  {
    _id: 3, kategoriya_id: 1, nomer_shaga: 3,
    nazvanie: "Изучение теоретического материала",
    opisanie: "Систематическое изучение теории по всем разделам программы с конспектированием.",
    organizatsiya: "Преподаватель предмета", obyazatelnyy: true, srok_dney: 30,
    kriterii_otlichno: "Изучены все темы программы, конспекты оформлены и проверены преподавателем",
    materialy: [
      { tip_materiala_id: 1, obyazatelnyy: true },
      { tip_materiala_id: 2, obyazatelnyy: true },
      { tip_materiala_id: 4, obyazatelnyy: false },
      { tip_materiala_id: 7, obyazatelnyy: false }
    ]
  },
  {
    _id: 4, kategoriya_id: 1, nomer_shaga: 4,
    nazvanie: "Решение типовых задач и упражнений",
    opisanie: "Практика решения задач по каждой теме с разбором ошибок.",
    organizatsiya: "Тьютор/куратор", obyazatelnyy: true, srok_dney: 20,
    kriterii_otlichno: "Решено не менее 90% типовых задач без ошибок, разобраны все типичные ошибки",
    materialy: [
      { tip_materiala_id: 3, obyazatelnyy: true },
      { tip_materiala_id: 5, obyazatelnyy: true },
      { tip_materiala_id: 8, obyazatelnyy: true }
    ]
  },
  {
    _id: 5, kategoriya_id: 1, nomer_shaga: 5,
    nazvanie: "Промежуточные контрольные тесты",
    opisanie: "Регулярные проверочные работы по пройденным разделам с целью отслеживания прогресса.",
    organizatsiya: "Экзаменатор", obyazatelnyy: true, srok_dney: 10,
    kriterii_otlichno: "Все промежуточные тесты сданы на оценку «5», средний балл не ниже 4,8",
    materialy: [
      { tip_materiala_id: 3, obyazatelnyy: true },
      { tip_materiala_id: 8, obyazatelnyy: true }
    ]
  },
  {
    _id: 6, kategoriya_id: 1, nomer_shaga: 6,
    nazvanie: "Повторение и закрепление материала",
    opisanie: "Систематическое повторение всех тем, работа над ошибками, закрепление сложных разделов.",
    organizatsiya: "Тьютор/куратор", obyazatelnyy: true, srok_dney: 15,
    kriterii_otlichno: "Проведено полное повторение программы, устранены все выявленные пробелы",
    materialy: [
      { tip_materiala_id: 2, obyazatelnyy: true },
      { tip_materiala_id: 6, obyazatelnyy: true },
      { tip_materiala_id: 10, obyazatelnyy: false }
    ]
  },
  {
    _id: 7, kategoriya_id: 1, nomer_shaga: 7,
    nazvanie: "Пробный экзамен",
    opisanie: "Полноценная имитация итогового экзамена в условиях, максимально близких к реальным.",
    organizatsiya: "Экзаменатор", obyazatelnyy: true, srok_dney: 3,
    kriterii_otlichno: "Пробный экзамен сдан на оценку «5», время прохождения не превышает установленного",
    materialy: [
      { tip_materiala_id: 9, obyazatelnyy: true }
    ]
  },
  {
    _id: 8, kategoriya_id: 1, nomer_shaga: 8,
    nazvanie: "Итоговый экзамен",
    opisanie: "Финальный экзамен, по результатам которого выставляется итоговая оценка.",
    organizatsiya: "Экзаменатор", obyazatelnyy: true, srok_dney: 2,
    kriterii_otlichno: "Экзамен сдан на оценку «5» (отлично), выдан сертификат об отличной подготовке",
    materialy: []
  }
])

// =====================================================================
// 7. PREPODAVATEL — преподаватели и сотрудники
// =====================================================================
db.prepodavatel.insertMany([
  { _id: 1, imya: "Елена", familiya: "Васильева", otchestvo: "Анатольевна", telefon: "+79151112233", email: "elena.math@center.ru", dolzhnost_id: 1 },
  { _id: 2, imya: "Игорь", familiya: "Смирнов", otchestvo: "Петрович", telefon: "+79152223344", email: "igor.rus@center.ru", dolzhnost_id: 1 },
  { _id: 3, imya: "Мария", familiya: "Козлова", otchestvo: "Сергеевна", telefon: "+79153334455", email: "maria.inf@center.ru", dolzhnost_id: 1 },
  { _id: 4, imya: "Дмитрий", familiya: "Орлов", otchestvo: "Викторович", telefon: "+79154445566", email: "dmitry.phys@center.ru", dolzhnost_id: 1 },
  { _id: 5, imya: "Ольга", familiya: "Новикова", otchestvo: "Андреевна", telefon: "+79155556677", email: "olga.ang@center.ru", dolzhnost_id: 1 },
  { _id: 6, imya: "Сергей", familiya: "Морозов", otchestvo: "Игоревич", telefon: "+79156667788", email: "sergey@center.ru", dolzhnost_id: 2 },
  { _id: 7, imya: "Татьяна", familiya: "Егорова", otchestvo: "Дмитриевна", telefon: "+79157778899", email: "tatyana@center.ru", dolzhnost_id: 3 },
  { _id: 8, imya: "Андрей", familiya: "Титов", otchestvo: "Николаевич", telefon: "+79158889900", email: "andrey.exam@center.ru", dolzhnost_id: 4 },
  { _id: 9, imya: "Наталья", familiya: "Попова", otchestvo: "Ивановна", telefon: "+79159990011", email: "natalya@center.ru", dolzhnost_id: 5 },
  { _id: 10, imya: "Виктор", familiya: "Сидоров", otchestvo: "Алексеевич", telefon: "+79160001122", email: "viktor@center.ru", dolzhnost_id: 6 }
])

// =====================================================================
// 8. STUDENT — обучающиеся
// =====================================================================
db.student.insertMany([
  { _id: 1, imya: "Алексей", familiya: "Кузнецов", otchestvo: "Петрович", data_rozhdeniya: new Date("2005-04-15"), telefon: "+79201112233", email: "alexey.kuznetsov@mail.ru", adres: "Москва, ул. Ленина, 10, кв. 15", data_registratsii: new Date("2026-09-01") },
  { _id: 2, imya: "Анна", familiya: "Смирнова", otchestvo: "Ивановна", data_rozhdeniya: new Date("2005-08-22"), telefon: "+79202223344", email: "anna.smirnova@mail.ru", adres: "Москва, Невский пр., 25, кв. 7", data_registratsii: new Date("2026-09-02") },
  { _id: 3, imya: "Сергей", familiya: "Иванов", otchestvo: "Петрович", data_rozhdeniya: new Date("2004-11-10"), telefon: "+79203334455", email: "sergey.ivanov@mail.ru", adres: "Москва, ул. Баумана, 7, кв. 41", data_registratsii: new Date("2026-09-03") },
  { _id: 4, imya: "Мария", familiya: "Козлова", otchestvo: "Андреевна", data_rozhdeniya: new Date("2005-06-30"), telefon: "+79204445566", email: "maria.kozlova@mail.ru", adres: "Москва, Красный пр., 100, кв. 3", data_registratsii: new Date("2026-09-04") },
  { _id: 5, imya: "Дмитрий", familiya: "Орлов", otchestvo: "Викторович", data_rozhdeniya: new Date("2006-01-12"), telefon: "+79205556677", email: "dmitry.orlov@mail.ru", adres: "Москва, ул. Ленина, 24, кв. 88", data_registratsii: new Date("2026-09-05") },
  { _id: 6, imya: "Ольга", familiya: "Новикова", otchestvo: "Сергеевна", data_rozhdeniya: new Date("2005-02-28"), telefon: "+79206667788", email: "olga.novikova@mail.ru", adres: "Москва, Тверская ул., 15, кв. 12", data_registratsii: new Date("2026-09-06") },
  { _id: 7, imya: "Павел", familiya: "Морозов", otchestvo: "Игоревич", data_rozhdeniya: new Date("2004-09-09"), telefon: "+79207778899", email: "pavel.morozov@mail.ru", adres: "Москва, Курортная ул., 33, кв. 5", data_registratsii: new Date("2026-09-07") },
  { _id: 8, imya: "Елена", familiya: "Волкова", otchestvo: "Дмитриевна", data_rozhdeniya: new Date("2005-12-11"), telefon: "+79208889900", email: "elena.volkova@mail.ru", adres: "Москва, Арбат, 5, кв. 20", data_registratsii: new Date("2026-09-08") },
  { _id: 9, imya: "Артём", familiya: "Соколов", otchestvo: "Олегович", data_rozhdeniya: new Date("2006-03-14"), telefon: "+79209990011", email: "artem.sokolov@mail.ru", adres: "Москва, Светланская ул., 9, кв. 61", data_registratsii: new Date("2026-09-09") },
  { _id: 10, imya: "Ксения", familiya: "Лебедева", otchestvo: "Павловна", data_rozhdeniya: new Date("2005-07-20"), telefon: "+79210001122", email: "ksenia.lebedeva@mail.ru", adres: "Москва, Красная ул., 155, кв. 34", data_registratsii: new Date("2026-09-10") }
])

// =====================================================================
// 9. GRUPPA_PODGOTOVKI — учебные группы подготовки
// =====================================================================
db.gruppa_podgotovki.insertMany([
  { _id: 1, nazvanie: "МATH-26-01", kategoriya_id: 1, prepodavatel_id: 1, data_nachala: new Date("2026-09-10"), data_okonchaniya: new Date("2026-12-10") },
  { _id: 2, nazvanie: "RUS-26-01", kategoriya_id: 2, prepodavatel_id: 2, data_nachala: new Date("2026-09-10"), data_okonchaniya: new Date("2026-12-10") },
  { _id: 3, nazvanie: "INF-26-01", kategoriya_id: 3, prepodavatel_id: 3, data_nachala: new Date("2026-09-15"), data_okonchaniya: new Date("2026-12-15") },
  { _id: 4, nazvanie: "PHYS-26-01", kategoriya_id: 4, prepodavatel_id: 4, data_nachala: new Date("2026-09-12"), data_okonchaniya: new Date("2026-12-12") },
  { _id: 5, nazvanie: "ANG-26-01", kategoriya_id: 5, prepodavatel_id: 5, data_nachala: new Date("2026-09-14"), data_okonchaniya: new Date("2026-12-14") },
  { _id: 6, nazvanie: "MATH-26-02", kategoriya_id: 1, prepodavatel_id: 1, data_nachala: new Date("2026-10-01"), data_okonchaniya: null },
  { _id: 7, nazvanie: "RUS-26-02", kategoriya_id: 2, prepodavatel_id: 2, data_nachala: new Date("2026-10-01"), data_okonchaniya: null }
])

// =====================================================================
// 10. PLAN_PODGOTOVKI — планы подготовки (основной документ со вложенными этапами, зачислениями, тестами, платежами)
// =====================================================================
db.plan_podgotovki.insertMany([
  {
    _id: 1, student_id: 1, kategoriya_id: 1, prepodavatel_id: 1, status_id: 4,
    data_nachala: new Date("2026-09-10"), primechanie: "Цель — получить «5» по математике",
    zachisleniya: [
      { gruppa_id: 1, kurator_id: 7, chasov_teorii: 40, chasov_praktiki: 30 }
    ],
    prokhozhdenie_etapy: [
      { etap_id: 1, status: "proyden", data_nachala: new Date("2026-09-10"), data_zaversheniya: new Date("2026-09-11"), otsenka: 5, kommentariy: "Программа изучена, слабые темы выявлены" },
      { etap_id: 2, status: "proyden", data_nachala: new Date("2026-09-12"), data_zaversheniya: new Date("2026-09-12"), otsenka: 5, kommentariy: "Диагностика пройдена, план устранения пробелов составлен" },
      { etap_id: 3, status: "proyden", data_nachala: new Date("2026-09-13"), data_zaversheniya: new Date("2026-10-10"), otsenka: 5, kommentariy: "Теория изучена полностью, конспекты проверены" },
      { etap_id: 4, status: "proyden", data_nachala: new Date("2026-10-11"), data_zaversheniya: new Date("2026-10-30"), otsenka: 5, kommentariy: "Решено 95% типовых задач без ошибок" },
      { etap_id: 5, status: "proyden", data_nachala: new Date("2026-11-01"), data_zaversheniya: new Date("2026-11-05"), otsenka: 5, kommentariy: "Все промежуточные тесты на «5», средний балл 4,9" },
      { etap_id: 6, status: "proyden", data_nachala: new Date("2026-11-06"), data_zaversheniya: new Date("2026-11-20"), otsenka: 5, kommentariy: "Повторение завершено, все пробелы устранены" },
      { etap_id: 7, status: "proyden", data_nachala: new Date("2026-11-21"), data_zaversheniya: new Date("2026-11-23"), otsenka: 5, kommentariy: "Пробный экзамен сдан на «5», время в норме" },
      { etap_id: 8, status: "proyden", data_nachala: new Date("2026-11-24"), data_zaversheniya: new Date("2026-11-25"), otsenka: 5, kommentariy: "Итоговый экзамен сдан на отлично" }
    ],
    kontrolnye_testy: [
      { ekzamenator_id: 8, tip_testa: "diagnosticheskiy", nomer_popytki: 1, data_testa: new Date("2026-09-12T10:00:00"), kolvo_oshibok: 2, otsenka: 5, sdan_na_otlichno: true },
      { ekzamenator_id: 8, tip_testa: "promezhutochnyy", nomer_popytki: 1, data_testa: new Date("2026-10-15T10:00:00"), kolvo_oshibok: 1, otsenka: 5, sdan_na_otlichno: true },
      { ekzamenator_id: 8, tip_testa: "promezhutochnyy", nomer_popytki: 2, data_testa: new Date("2026-10-29T10:00:00"), kolvo_oshibok: 0, otsenka: 5, sdan_na_otlichno: true },
      { ekzamenator_id: 8, tip_testa: "itogovyy", nomer_popytki: 1, data_testa: new Date("2026-11-25T10:00:00"), kolvo_oshibok: 0, otsenka: 5, sdan_na_otlichno: true },
      { ekzamenator_id: 8, tip_testa: "probnyy", nomer_popytki: 1, data_testa: new Date("2026-11-23T10:00:00"), kolvo_oshibok: 1, otsenka: 5, sdan_na_otlichno: true }
    ],
    platezhi: [
      { sposob_id: 3, summa: 12000.00, data_platezha: new Date("2026-09-10T10:05:00"), naznachenie: "kurs" },
      { sposob_id: 3, summa: 1500.00, data_platezha: new Date("2026-09-15T10:05:00"), naznachenie: "materialy" },
      { sposob_id: 7, summa: 2000.00, data_platezha: new Date("2026-11-25T12:00:00"), naznachenie: "kurs" }
    ]
  },
  {
    _id: 2, student_id: 2, kategoriya_id: 2, prepodavatel_id: 2, status_id: 4,
    data_nachala: new Date("2026-09-10"), primechanie: "Цель — получить «5» по русскому языку",
    zachisleniya: [
      { gruppa_id: 2, kurator_id: 7, chasov_teorii: 35, chasov_praktiki: 25 }
    ],
    prokhozhdenie_etapy: [
      { etap_id: 1, status: "proyden", data_nachala: new Date("2026-09-10"), data_zaversheniya: new Date("2026-09-11"), otsenka: 5, kommentariy: "Программа изучена" },
      { etap_id: 2, status: "proyden", data_nachala: new Date("2026-09-12"), data_zaversheniya: new Date("2026-09-12"), otsenka: 5, kommentariy: "Диагностика пройдена" },
      { etap_id: 3, status: "proyden", data_nachala: new Date("2026-09-13"), data_zaversheniya: new Date("2026-10-12"), otsenka: 5, kommentariy: "Теория изучена" },
      { etap_id: 4, status: "proyden", data_nachala: new Date("2026-10-13"), data_zaversheniya: new Date("2026-11-01"), otsenka: 5, kommentariy: "Упражнения выполнены на отлично" },
      { etap_id: 5, status: "proyden", data_nachala: new Date("2026-11-02"), data_zaversheniya: new Date("2026-11-06"), otsenka: 5, kommentariy: "Промежуточные тесты на «5»" },
      { etap_id: 6, status: "proyden", data_nachala: new Date("2026-11-07"), data_zaversheniya: new Date("2026-11-20"), otsenka: 5, kommentariy: "Повторение завершено" },
      { etap_id: 7, status: "proyden", data_nachala: new Date("2026-11-21"), data_zaversheniya: new Date("2026-11-23"), otsenka: 5, kommentariy: "Пробный экзамен на «5»" },
      { etap_id: 8, status: "proyden", data_nachala: new Date("2026-11-24"), data_zaversheniya: new Date("2026-11-25"), otsenka: 5, kommentariy: "Итоговый экзамен на «5»" }
    ],
    kontrolnye_testy: [
      { ekzamenator_id: 8, tip_testa: "diagnosticheskiy", nomer_popytki: 1, data_testa: new Date("2026-09-12T11:00:00"), kolvo_oshibok: 3, otsenka: 5, sdan_na_otlichno: true },
      { ekzamenator_id: 8, tip_testa: "promezhutochnyy", nomer_popytki: 1, data_testa: new Date("2026-10-20T11:00:00"), kolvo_oshibok: 1, otsenka: 5, sdan_na_otlichno: true },
      { ekzamenator_id: 8, tip_testa: "itogovyy", nomer_popytki: 1, data_testa: new Date("2026-11-25T11:00:00"), kolvo_oshibok: 0, otsenka: 5, sdan_na_otlichno: true },
      { ekzamenator_id: 8, tip_testa: "probnyy", nomer_popytki: 1, data_testa: new Date("2026-11-23T11:00:00"), kolvo_oshibok: 2, otsenka: 5, sdan_na_otlichno: true }
    ],
    platezhi: [
      { sposob_id: 2, summa: 11000.00, data_platezha: new Date("2026-09-10T10:05:00"), naznachenie: "kurs" },
      { sposob_id: 7, summa: 2000.00, data_platezha: new Date("2026-11-25T12:00:00"), naznachenie: "kurs" }
    ]
  },
  {
    _id: 3, student_id: 3, kategoriya_id: 3, prepodavatel_id: 3, status_id: 2,
    data_nachala: new Date("2026-09-15"), primechanie: "Идет подготовка к информатике",
    zachisleniya: [
      { gruppa_id: 3, kurator_id: 7, chasov_teorii: 20, chasov_praktiki: 25 }
    ],
    prokhozhdenie_etapy: [
      { etap_id: 1, status: "proyden", data_nachala: new Date("2026-09-15"), data_zaversheniya: new Date("2026-09-16"), otsenka: 5, kommentariy: "Программа изучена" },
      { etap_id: 2, status: "proyden", data_nachala: new Date("2026-09-17"), data_zaversheniya: new Date("2026-09-17"), otsenka: 4, kommentariy: "Диагностика пройдена" },
      { etap_id: 3, status: "v_protsesse", data_nachala: new Date("2026-09-18"), data_zaversheniya: null, otsenka: null, kommentariy: "Изучение теории в процессе" },
      { etap_id: 4, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, otsenka: null, kommentariy: null },
      { etap_id: 5, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, otsenka: null, kommentariy: null },
      { etap_id: 6, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, otsenka: null, kommentariy: null },
      { etap_id: 7, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, otsenka: null, kommentariy: null },
      { etap_id: 8, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, otsenka: null, kommentariy: null }
    ],
    kontrolnye_testy: [
      { ekzamenator_id: 8, tip_testa: "diagnosticheskiy", nomer_popytki: 1, data_testa: new Date("2026-09-17T10:00:00"), kolvo_oshibok: 5, otsenka: 4, sdan_na_otlichno: false }
    ],
    platezhi: [
      { sposob_id: 3, summa: 10000.00, data_platezha: new Date("2026-09-15T10:05:00"), naznachenie: "kurs" }
    ]
  },
  {
    _id: 4, student_id: 4, kategoriya_id: 4, prepodavatel_id: 4, status_id: 2,
    data_nachala: new Date("2026-09-12"), primechanie: "Подготовка к физике",
    zachisleniya: [
      { gruppa_id: 4, kurator_id: 7, chasov_teorii: 30, chasov_praktiki: 20 }
    ],
    prokhozhdenie_etapy: [
      { etap_id: 1, status: "proyden", data_nachala: new Date("2026-09-12"), data_zaversheniya: new Date("2026-09-13"), otsenka: 5, kommentariy: "Программа изучена" },
      { etap_id: 2, status: "proyden", data_nachala: new Date("2026-09-14"), data_zaversheniya: new Date("2026-09-14"), otsenka: 5, kommentariy: "Диагностика пройдена" },
      { etap_id: 3, status: "v_protsesse", data_nachala: new Date("2026-09-15"), data_zaversheniya: null, otsenka: null, kommentariy: "Теория изучается" },
      { etap_id: 4, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, otsenka: null, kommentariy: null },
      { etap_id: 5, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, otsenka: null, kommentariy: null },
      { etap_id: 6, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, otsenka: null, kommentariy: null },
      { etap_id: 7, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, otsenka: null, kommentariy: null },
      { etap_id: 8, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, otsenka: null, kommentariy: null }
    ],
    kontrolnye_testy: [
      { ekzamenator_id: 8, tip_testa: "diagnosticheskiy", nomer_popytki: 1, data_testa: new Date("2026-09-14T10:00:00"), kolvo_oshibok: 2, otsenka: 5, sdan_na_otlichno: true },
      { ekzamenator_id: 8, tip_testa: "promezhutochnyy", nomer_popytki: 1, data_testa: new Date("2026-10-05T10:00:00"), kolvo_oshibok: 3, otsenka: 4, sdan_na_otlichno: false }
    ],
    platezhi: [
      { sposob_id: 2, summa: 12000.00, data_platezha: new Date("2026-09-12T10:05:00"), naznachenie: "kurs" },
      { sposob_id: 3, summa: 800.00, data_platezha: new Date("2026-09-20T10:05:00"), naznachenie: "materialy" }
    ]
  },
  {
    _id: 5, student_id: 5, kategoriya_id: 5, prepodavatel_id: 5, status_id: 5,
    data_nachala: new Date("2026-09-14"), primechanie: "Приостановлено по заявлению студента",
    zachisleniya: [
      { gruppa_id: 5, kurator_id: 7, chasov_teorii: 10, chasov_praktiki: 5 }
    ],
    prokhozhdenie_etapy: [
      { etap_id: 1, status: "proyden", data_nachala: new Date("2026-09-14"), data_zaversheniya: new Date("2026-09-15"), otsenka: 5, kommentariy: "Программа изучена" },
      { etap_id: 2, status: "proyden", data_nachala: new Date("2026-09-16"), data_zaversheniya: new Date("2026-09-16"), otsenka: 4, kommentariy: "Диагностика пройдена" },
      { etap_id: 3, status: "v_protsesse", data_nachala: new Date("2026-09-17"), data_zaversheniya: null, otsenka: null, kommentariy: "Приостановлено по заявлению студента" },
      { etap_id: 4, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, otsenka: null, kommentariy: null },
      { etap_id: 5, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, otsenka: null, kommentariy: null },
      { etap_id: 6, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, otsenka: null, kommentariy: null },
      { etap_id: 7, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, otsenka: null, kommentariy: null },
      { etap_id: 8, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, otsenka: null, kommentariy: null }
    ],
    kontrolnye_testy: [
      { ekzamenator_id: 8, tip_testa: "diagnosticheskiy", nomer_popytki: 1, data_testa: new Date("2026-09-16T10:00:00"), kolvo_oshibok: 4, otsenka: 4, sdan_na_otlichno: false }
    ],
    platezhi: [
      { sposob_id: 5, summa: 5000.00, data_platezha: new Date("2026-09-14T10:05:00"), naznachenie: "kurs" }
    ]
  }
])

// =====================================================================
// 11. SPRAVKA_O_GOTOVNOSTI — справки о готовности к экзамену
// =====================================================================
db.spravka_o_gotovnosti.insertMany([
  { _id: 1, student_id: 1, nomer: "SG-2026-0001", organizatsiya: "Образовательный центр «Знание»", data_vydachi: new Date("2026-11-25"), data_okonchaniya: new Date("2027-11-25"), gotov_k_ekzamenu: true },
  { _id: 2, student_id: 2, nomer: "SG-2026-0002", organizatsiya: "Образовательный центр «Знание»", data_vydachi: new Date("2026-11-25"), data_okonchaniya: new Date("2027-11-25"), gotov_k_ekzamenu: true },
  { _id: 3, student_id: 3, nomer: "SG-2026-0003", organizatsiya: "Образовательный центр «Знание»", data_vydachi: new Date("2026-09-30"), data_okonchaniya: new Date("2026-12-30"), gotov_k_ekzamenu: false },
  { _id: 4, student_id: 4, nomer: "SG-2026-0004", organizatsiya: "Образовательный центр «Знание»", data_vydachi: new Date("2026-09-30"), data_okonchaniya: new Date("2026-12-30"), gotov_k_ekzamenu: false }
])

// =====================================================================
// 12. SERTIFIKAT_OTLICHIYA — сертификаты об отличной подготовке (итоговая оценка 5)
// =====================================================================
db.sertifikat_otlichiya.insertMany([
  { _id: 1, plan_id: 1, nomer: "SO-2026-10001", data_vydachi: new Date("2026-11-25"), data_okonchaniya: new Date("2027-11-25"), podrazdelenie: "Образовательный центр «Знание», отдел математики", itogovaya_otsenka: 5 },
  { _id: 2, plan_id: 2, nomer: "SO-2026-10002", data_vydachi: new Date("2026-11-25"), data_okonchaniya: new Date("2027-11-25"), podrazdelenie: "Образовательный центр «Знание», отдел русского языка", itogovaya_otsenka: 5 }
])

// =====================================================================
// 13. MATERIAL_STUDENTA — материалы, выданные студентам
// =====================================================================
db.material_studenta.insertMany([
  { _id: 1, student_id: 1, tip_materiala_id: 1, nazvanie: "Математика. Полный курс подготовки к экзамену", nomer: "MATH-TXT-001", istochnik: "Издательство «Просвещение»", data_polucheniya: new Date("2026-09-12"), data_aktualnosti: new Date("2027-09-12") },
  { _id: 2, student_id: 1, tip_materiala_id: 2, nazvanie: "Конспект лекций по алгебре и геометрии", nomer: "MATH-CONS-001", istochnik: "Преподаватель Е.А. Васильева", data_polucheniya: new Date("2026-09-15"), data_aktualnosti: new Date("2027-09-15") },
  { _id: 3, student_id: 1, tip_materiala_id: 3, nazvanie: "Тестовые задания по математике (варианты 1-50)", nomer: "MATH-TEST-001", istochnik: "ФИПИ", data_polucheniya: new Date("2026-09-20"), data_aktualnosti: new Date("2027-09-20") },
  { _id: 4, student_id: 2, tip_materiala_id: 1, nazvanie: "Русский язык. Подготовка к экзамену", nomer: "RUS-TXT-001", istochnik: "Издательство «Просвещение»", data_polucheniya: new Date("2026-09-12"), data_aktualnosti: new Date("2027-09-12") },
  { _id: 5, student_id: 2, tip_materiala_id: 6, nazvanie: "Таблицы орфограмм и пунктуации", nomer: "RUS-MNEM-001", istochnik: "Методист С.И. Морозов", data_polucheniya: new Date("2026-09-15"), data_aktualnosti: new Date("2027-09-15") },
  { _id: 6, student_id: 3, tip_materiala_id: 4, nazvanie: "Видеолекции по информатике", nomer: "INF-VIDEO-001", istochnik: "Онлайн-платформа «ИнфоУрок»", data_polucheniya: new Date("2026-09-18"), data_aktualnosti: new Date("2027-09-18") },
  { _id: 7, student_id: 4, tip_materiala_id: 1, nazvanie: "Физика. Учебник для подготовки к экзамену", nomer: "PHYS-TXT-001", istochnik: "Издательство «Дрофа»", data_polucheniya: new Date("2026-09-15"), data_aktualnosti: new Date("2027-09-15") },
  { _id: 8, student_id: 5, tip_materiala_id: 4, nazvanie: "Видеолекции по английскому языку", nomer: "ANG-VIDEO-001", istochnik: "Онлайн-школа «SkyEng»", data_polucheniya: new Date("2026-09-17"), data_aktualnosti: new Date("2027-09-17") }
])

// =====================================================================
// 14. ИТОГОВЫЙ ВЫВОД
// =====================================================================
print("========== ПОДГОТОВКА К ЭКЗАМЕНУ НА «ОТЛИЧНО» — ИТОГ ==========")
db.getCollectionNames().sort().forEach(function(c) {
  print(c + ": " + db[c].countDocuments() + " документов")
})
print("================================================================")
