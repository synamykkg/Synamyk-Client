// final List<Map<String, dynamic>> fakeOrtTest = [
//   {
//     "id": "1",
//     "question": "What is the capital of France?",
//     "image": "https://example.com/images/france.png",
//     "options": ["Paris", "Berlin", "Rome", "Madrid"],
//     "correctAnswer": "Paris",
//   },
//   {
//     "id": "2",
//     "question": "Select the correct translation: 'Cat' in Spanish",
//     "image": "",
//     "options": ["Gato", "Perro", "Pájaro", "Caballo"],
//     "correctAnswer": "Gato",
//   },
//   {
//     "id": "3",
//     "question": "Which color is created by mixing red and blue?",
//     "image": "https://example.com/images/colors.png",
//     "options": ["Purple", "Green", "Orange", "Brown"],
//     "correctAnswer": "Purple",
//   },
// ];

final List<Map<String, dynamic>> fakeOrtTest = [
  {
    "id": "1",
    "question": "What is the capital of France?",
    "image": "https://example.com/images/france.png",
    "options": [
      {"variant": "A", "optionsAnswer": "Paris"},
      {"variant": "B", "optionsAnswer": "Berlin"},
      {"variant": "C", "optionsAnswer": "Rome"},
      {"variant": "D", "optionsAnswer": "Madrid"},
    ],
    "correctAnswer": "Paris",
  },
  {
    "id": "2",
    "question": "Select the correct translation: 'Cat' in Spanish",
    "image": "",
    "options": [
      {"variant": "A", "optionsAnswer": "Gato"},
      {"variant": "B", "optionsAnswer": "Perro"},
      {"variant": "C", "optionsAnswer": "Pájaro"},
      {"variant": "D", "optionsAnswer": "Caballo"},
    ],
    "correctAnswer": "Gato",
  },
  {
    "id": "3",
    "question": "Which color is created by mixing red and blue?",
    "image": "https://example.com/images/colors.png",
    "options": [
      {"variant": "A", "optionsAnswer": "Purple"},
      {"variant": "B", "optionsAnswer": "Green"},
      {"variant": "C", "optionsAnswer": "Orange"},
      {"variant": "D", "optionsAnswer": "Brown"},
    ],
    "correctAnswer": "Green",
  },
];

final List<Map<String, dynamic>> fakeEnglishOrtTests = [
  {
    "id": "eng_test_1",
    "tests": [
      {
        "id": "1",
        "question": "What is the capital of the United Kingdom?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "London"},
          {"variant": "B", "optionsAnswer": "Manchester"},
          {"variant": "C", "optionsAnswer": "Liverpool"},
          {"variant": "D", "optionsAnswer": "Birmingham"},
        ],
        "correctAnswer": "London",
      },
      {
        "id": "2",
        "question": "Choose the correct translation: 'Apple'",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Banana"},
          {"variant": "B", "optionsAnswer": "Orange"},
          {"variant": "C", "optionsAnswer": "Apple"},
          {"variant": "D", "optionsAnswer": "Grape"},
        ],
        "correctAnswer": "Apple",
      },
      {
        "id": "3",
        "question": "Which word is a verb?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Run"},
          {"variant": "B", "optionsAnswer": "Blue"},
          {"variant": "C", "optionsAnswer": "Fast"},
          {"variant": "D", "optionsAnswer": "Happy"},
        ],
        "correctAnswer": "Run",
      },
      {
        "id": "4",
        "question": "Choose the correct article: ___ cat is sleeping.",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "A"},
          {"variant": "B", "optionsAnswer": "An"},
          {"variant": "C", "optionsAnswer": "The"},
          {"variant": "D", "optionsAnswer": "No article"},
        ],
        "correctAnswer": "The",
      },
      {
        "id": "5",
        "question": "Choose the plural form of 'child'",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Childs"},
          {"variant": "B", "optionsAnswer": "Children"},
          {"variant": "C", "optionsAnswer": "Childes"},
          {"variant": "D", "optionsAnswer": "Childrens"},
        ],
        "correctAnswer": "Children",
      },
      {
        "id": "6",
        "question": "Which word is an adjective?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Quickly"},
          {"variant": "B", "optionsAnswer": "Beauty"},
          {"variant": "C", "optionsAnswer": "Fast"},
          {"variant": "D", "optionsAnswer": "Run"},
        ],
        "correctAnswer": "Fast",
      },
      {
        "id": "7",
        "question": "Choose the correct translation: 'House'",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Car"},
          {"variant": "B", "optionsAnswer": "House"},
          {"variant": "C", "optionsAnswer": "Tree"},
          {"variant": "D", "optionsAnswer": "Road"},
        ],
        "correctAnswer": "House",
      },
      {
        "id": "8",
        "question": "What color is the sky on a clear day?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Green"},
          {"variant": "B", "optionsAnswer": "Blue"},
          {"variant": "C", "optionsAnswer": "Red"},
          {"variant": "D", "optionsAnswer": "Black"},
        ],
        "correctAnswer": "Blue",
      },
      {
        "id": "9",
        "question": "Choose the correct word: I ___ coffee every morning.",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "drink"},
          {"variant": "B", "optionsAnswer": "drinks"},
          {"variant": "C", "optionsAnswer": "drank"},
          {"variant": "D", "optionsAnswer": "drinking"},
        ],
        "correctAnswer": "drink",
      },
    ],
  },

  {
    "id": "eng_test_2",
    "tests": [
      {
        "id": "1",
        "question": "Which sentence is correct?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "She go to school"},
          {"variant": "B", "optionsAnswer": "She goes to school"},
          {"variant": "C", "optionsAnswer": "She going to school"},
          {"variant": "D", "optionsAnswer": "She gone to school"},
        ],
        "correctAnswer": "She goes to school",
      },
      {
        "id": "2",
        "question": "Choose the correct form: He ___ football on Sundays.",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "play"},
          {"variant": "B", "optionsAnswer": "plays"},
          {"variant": "C", "optionsAnswer": "played"},
          {"variant": "D", "optionsAnswer": "playing"},
        ],
        "correctAnswer": "plays",
      },
      {
        "id": "3",
        "question": "Choose the negative form: I ___ like milk.",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "don't"},
          {"variant": "B", "optionsAnswer": "doesn't"},
          {"variant": "C", "optionsAnswer": "didn't"},
          {"variant": "D", "optionsAnswer": "not"},
        ],
        "correctAnswer": "don't",
      },
      {
        "id": "4",
        "question": "Which word is a noun?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Run"},
          {"variant": "B", "optionsAnswer": "Blue"},
          {"variant": "C", "optionsAnswer": "Happiness"},
          {"variant": "D", "optionsAnswer": "Quickly"},
        ],
        "correctAnswer": "Happiness",
      },
      {
        "id": "5",
        "question": "Choose the correct question form: ___ you like tea?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Do"},
          {"variant": "B", "optionsAnswer": "Does"},
          {"variant": "C", "optionsAnswer": "Did"},
          {"variant": "D", "optionsAnswer": "Are"},
        ],
        "correctAnswer": "Do",
      },
      {
        "id": "6",
        "question": "Choose the correct translation: 'Book'",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Pen"},
          {"variant": "B", "optionsAnswer": "Book"},
          {"variant": "C", "optionsAnswer": "Table"},
          {"variant": "D", "optionsAnswer": "Chair"},
        ],
        "correctAnswer": "Book",
      },
      {
        "id": "7",
        "question": "Which sentence is negative?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "I like apples"},
          {"variant": "B", "optionsAnswer": "I don't like apples"},
          {"variant": "C", "optionsAnswer": "I am like apples"},
          {"variant": "D", "optionsAnswer": "I likes apples"},
        ],
        "correctAnswer": "I don't like apples",
      },
      {
        "id": "8",
        "question": "Choose the correct form: We ___ at home now.",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "am"},
          {"variant": "B", "optionsAnswer": "is"},
          {"variant": "C", "optionsAnswer": "are"},
          {"variant": "D", "optionsAnswer": "be"},
        ],
        "correctAnswer": "are",
      },
      {
        "id": "9",
        "question": "Choose the correct word: The sun ___ in the east.",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "rise"},
          {"variant": "B", "optionsAnswer": "rises"},
          {"variant": "C", "optionsAnswer": "rose"},
          {"variant": "D", "optionsAnswer": "rising"},
        ],
        "correctAnswer": "rises",
      },
    ],
  },

  // eng_test_3 … eng_test_8
];

final Map<String, dynamic> subjectsTests = {
  "en": {
    "eng_test_1": [
      {
        "id": "1",
        "question": "What is the capital of France?",
        "image": "https://example.com/images/france.png",
        "options": [
          {"variant": "A", "optionsAnswer": "Paris"},
          {"variant": "B", "optionsAnswer": "Berlin"},
          {"variant": "C", "optionsAnswer": "Rome"},
          {"variant": "D", "optionsAnswer": "Madrid"},
        ],
        "correctAnswer": "Paris",
      },
      {
        "id": "2",
        "question": "Which word is a synonym of 'happy'?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Sad"},
          {"variant": "B", "optionsAnswer": "Joyful"},
          {"variant": "C", "optionsAnswer": "Angry"},
          {"variant": "D", "optionsAnswer": "Tired"},
        ],
        "correctAnswer": "Joyful",
      },
      {
        "id": "3",
        "question": "Select the correct article: ___ apple",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "A"},
          {"variant": "B", "optionsAnswer": "An"},
          {"variant": "C", "optionsAnswer": "The"},
          {"variant": "D", "optionsAnswer": "No article"},
        ],
        "correctAnswer": "An",
      },
      // добавь остальные вопросы до 9
    ],
  },

  // eng_test_2 ... eng_test_8
  "he": {
    "heb_test_1": [
      {
        "id": "1",
        "question": "מהי עיר הבירה של ישראל?",
        "image": "https://example.com/images/telaviv.png",
        "options": [
          {"variant": "A", "optionsAnswer": "תל אביב"},
          {"variant": "B", "optionsAnswer": "ירושלים"},
          {"variant": "C", "optionsAnswer": "חיפה"},
          {"variant": "D", "optionsAnswer": "באר שבע"},
        ],
        "correctAnswer": "ירושלים",
      },
      {
        "id": "2",
        "question": "בחר את התרגום הנכון למילה 'Cat'",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "חתול"},
          {"variant": "B", "optionsAnswer": "כלב"},
          {"variant": "C", "optionsAnswer": "ציפור"},
          {"variant": "D", "optionsAnswer": "סוס"},
        ],
        "correctAnswer": "חתול",
      },
      {
        "id": "3",
        "question": "איזו מילה היא תואר?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "רוץ"},
          {"variant": "B", "optionsAnswer": "יפה"},
          {"variant": "C", "optionsAnswer": "מהר"},
          {"variant": "D", "optionsAnswer": "אושר"},
        ],
        "correctAnswer": "יפה",
      },
      // добавь остальные вопросы до 9
    ],
  },
  "ky": {
    "kg_test_1": [
      {
        "id": "1",
        "question": "Кыргызстандын борбор шаары кайсы?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Бишкек"},
          {"variant": "B", "optionsAnswer": "Ош"},
          {"variant": "C", "optionsAnswer": "Нарын"},
          {"variant": "D", "optionsAnswer": "Талас"},
        ],
        "correctAnswer": "Бишкек",
      },
      {
        "id": "2",
        "question": "'Салам' сөзүнүн мааниси эмнени билдирет?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Hello"},
          {"variant": "B", "optionsAnswer": "Goodbye"},
          {"variant": "C", "optionsAnswer": "Thanks"},
          {"variant": "D", "optionsAnswer": "Sorry"},
        ],
        "correctAnswer": "Hello",
      },
      {
        "id": "3",
        "question": "Кыргыз тилинде 'Ай' деген эмне?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Суу"},
          {"variant": "B", "optionsAnswer": "Ай"},
          {"variant": "C", "optionsAnswer": "Күн"},
          {"variant": "D", "optionsAnswer": "Жылдыз"},
        ],
        "correctAnswer": "Ай",
      },
      {
        "id": "4",
        "question": "Кыргыз тилинде 'Ай' деген эмне?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Суу"},
          {"variant": "B", "optionsAnswer": "Ай"},
          {"variant": "C", "optionsAnswer": "Күн"},
          {"variant": "D", "optionsAnswer": "Жылдыз"},
        ],
        "correctAnswer": "Ай",
      },
      {
        "id": "5",
        "question": "Кыргыз тилинде 'Ай' деген эмне?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Суу"},
          {"variant": "B", "optionsAnswer": "Ай"},
          {"variant": "C", "optionsAnswer": "Күн"},
          {"variant": "D", "optionsAnswer": "Жылдыз"},
        ],
        "correctAnswer": "Ай",
      },
      {
        "id": "6",
        "question": "Кыргыз тилинде 'Ай' деген эмне?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Суу"},
          {"variant": "B", "optionsAnswer": "Ай"},
          {"variant": "C", "optionsAnswer": "Күн"},
          {"variant": "D", "optionsAnswer": "Жылдыз"},
        ],
        "correctAnswer": "Ай",
      },
      {
        "id": "7",
        "question": "Кыргыз тилинде 'Ай' деген эмне?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Суу"},
          {"variant": "B", "optionsAnswer": "Ай"},
          {"variant": "C", "optionsAnswer": "Күн"},
          {"variant": "D", "optionsAnswer": "Жылдыз"},
        ],
        "correctAnswer": "Ай",
      },
      {
        "id": "8",
        "question": "Кыргыз тилинде 'Ай' деген эмне?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Суу"},
          {"variant": "B", "optionsAnswer": "Ай"},
          {"variant": "C", "optionsAnswer": "Күн"},
          {"variant": "D", "optionsAnswer": "Жылдыз"},
        ],
        "correctAnswer": "Ай",
      },
      {
        "id": "9",
        "question": "Кыргыз тилинде 'Ай' деген эмне?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Суу"},
          {"variant": "B", "optionsAnswer": "Ай"},
          {"variant": "C", "optionsAnswer": "Күн"},
          {"variant": "D", "optionsAnswer": "Жылдыз"},
        ],
        "correctAnswer": "Ай",
      },
      {
        "id": "10",
        "question": "Кыргыз тилинде 'Ай' деген эмне?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Суу"},
          {"variant": "B", "optionsAnswer": "Ай"},
          {"variant": "C", "optionsAnswer": "Күн"},
          {"variant": "D", "optionsAnswer": "Жылдыз"},
        ],
        "correctAnswer": "Ай",
      },
      {
        "id": "11",
        "question": "Кыргыз тилинде 'Ай' деген эмне?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Суу"},
          {"variant": "B", "optionsAnswer": "Ай"},
          {"variant": "C", "optionsAnswer": "Күн"},
          {"variant": "D", "optionsAnswer": "Жылдыз"},
        ],
        "correctAnswer": "Ай",
      },
      {
        "id": "12",
        "question": "Кыргыз тилинде 'Ай' деген эмне?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Суу"},
          {"variant": "B", "optionsAnswer": "Ай"},
          {"variant": "C", "optionsAnswer": "Күн"},
          {"variant": "D", "optionsAnswer": "Жылдыз"},
        ],
        "correctAnswer": "Ай",
      },
      {
        "id": "13",
        "question": "Кыргыз тилинде 'Ай' деген эмне?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Суу"},
          {"variant": "B", "optionsAnswer": "Ай"},
          {"variant": "C", "optionsAnswer": "Күн"},
          {"variant": "D", "optionsAnswer": "Жылдыз"},
        ],
        "correctAnswer": "Ай",
      },
      // остальные вопросы до 9
    ],
  },

  "ar": {
    "ar_test_1": [
      {
        "id": "1",
        "question": "ما هي عاصمة مصر؟",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "القاهرة"},
          {"variant": "B", "optionsAnswer": "الإسكندرية"},
          {"variant": "C", "optionsAnswer": "أسوان"},
          {"variant": "D", "optionsAnswer": "الأقصر"},
        ],
        "correctAnswer": "القاهرة",
      },
      {
        "id": "2",
        "question": "ما معنى كلمة 'كتاب'؟",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Pen"},
          {"variant": "B", "optionsAnswer": "Book"},
          {"variant": "C", "optionsAnswer": "Table"},
          {"variant": "D", "optionsAnswer": "Chair"},
        ],
        "correctAnswer": "Book",
      },
      {
        "id": "3",
        "question": "اختر الكلمة الصحيحة لوصف الشخص: سعيد",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Happy"},
          {"variant": "B", "optionsAnswer": "Sad"},
          {"variant": "C", "optionsAnswer": "Angry"},
          {"variant": "D", "optionsAnswer": "Tired"},
        ],
        "correctAnswer": "Happy",
      },
      // остальные вопросы до 9
    ],
  },

  "ru": {
    "ru_test_1": [
      {
        "id": "1",
        "question": "Столица России?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Москва"},
          {"variant": "B", "optionsAnswer": "Санкт-Петербург"},
          {"variant": "C", "optionsAnswer": "Новосибирск"},
          {"variant": "D", "optionsAnswer": "Казань"},
        ],
        "correctAnswer": "Москва",
      },
      {
        "id": "2",
        "question": "Как переводится слово 'Dog'?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "Кошка"},
          {"variant": "B", "optionsAnswer": "Собака"},
          {"variant": "C", "optionsAnswer": "Птица"},
          {"variant": "D", "optionsAnswer": "Мышь"},
        ],
        "correctAnswer": "Собака",
      },
      {
        "id": "3",
        "question": "Выберите правильное число: два + два = ?",
        "image": "",
        "options": [
          {"variant": "A", "optionsAnswer": "3"},
          {"variant": "B", "optionsAnswer": "4"},
          {"variant": "C", "optionsAnswer": "5"},
          {"variant": "D", "optionsAnswer": "6"},
        ],
        "correctAnswer": "4",
      },
      // остальные вопросы до 9
    ],
  },
};
