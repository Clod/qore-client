var diag1 = ['Diagnóstico 1', 'Diagnóstico 2', 'Diagnóstico 3'];

var diag2 = [
  // Rama Diagnóstico 1
  ['Diagnóstico 11', 'Diagnóstico 12', 'Diagnóstico 13'],
  // Rama Diagnóstico 2
  ['Diagnóstico 21', 'Diagnóstico 22'],
  // Rama Diagnóstico 3
  ['Diagnóstico 31', 'Diagnóstico 32', 'Diagnostico 33', 'Diagnostico 34']
];

var diag3 = [
  // Ramas del Diagnóstico 1
  [
    // Rama Diagnostico 1 - Diagnóstico 11
    ['Diagnóstico 111', 'Diagnóstico 112'],
    // Rama Diagnostico 1 - Diagnóstico 12
    ['Diagnóstico 121', 'Diagnóstico 122'],
    // Rama Diagnostico 1 - Diagnóstico 13
    ['Diagnóstico 131', 'Diagnóstico 132', 'Diagnóstico 133']
  ],
  // Ramas del Diagnóstico 2
  [
    // Rama Diagnostico 2 - Diagnóstico 21
    ['Diagnóstico 211', 'Diagnóstico 212'],
    // Rama Diagnostico 2 - Diagnóstico 22
    ['Diagnóstico 221', 'Diagnóstico 222']
  ],
  // Ramas Diagnostico 3
  [
    // Rama Diagnostico 31
    [
      'Diagnóstico 311',
      'Diagnóstico 312',
      'Diagnóstico 313',
      'Diagnóstico 314',
    ],
    // Rama Diagnostico 32
    [
      'Diagnóstico 321',
      'Diagnóstico 322',
      'Diagnóstico 323',
      'Diagnóstico 324',
    ],
    // Rama Diagnostico 33
    [
      'Diagnóstico 331',
      'Diagnóstico 332',
      'Diagnóstico 333',
      'Diagnóstico 334',
    ],
    // Rama Diagnostico 34
    [
      'Diagnóstico 341',
      'Diagnóstico 342',
      'Diagnóstico 343',
      'Diagnóstico 344',
    ],
  ]
];

var diag4 = [
  // Ramas diagnóstico 1
  [
    // Ramas diagnóstico 11
    [
      // Ramas diagnóstico 111
      ['Diagnóstico 1111', 'Diagnóstico 1112'],
      // Ramas diagnóstico 112
      ['Diagnóstico 1121', 'Diagnóstico 1122']
    ],
    // Ramas diagnóstico 12
    [
      // Ramas diagnóstico 121
      ['Diagnóstico 1211', 'Diagnóstico 1212'],
      // Ramas diagnóstico 122
      ['Diagnóstico 1221', 'Diagnóstico 1222']
    ],
    // Ramas diagnóstico 13
    [
      // Ramas diagnóstico 131
      [
        'Diagnóstico 1311',
      ],
      // Ramas diagnóstico 132
      [
        'Diagnóstico 1321',
      ],
      // Ramas diagnóstico 133
      ['Diagnóstico 1331', 'Diagnóstico 1332']
    ]
  ],
  // Ramas diagnóstico 2
  [
    // Ramas del diagnóstico 21
    [
      // Ramas del diagnóstico 211
      ['Diagnóstico 2111', 'Diagnóstico 2112'],
      // Ramas del diagnóstico 212
      ['Diagnóstico 2121', 'Diagnóstico 2122']
    ],
    // Ramas del diagnóstico 22
    [
      // Ramas del diagnóstico 221
      ['Diagnóstico 2211', 'Diagnóstico 2212'],
      // Ramas del diagnóstico 222
      ['Diagnóstico 2221', 'Diagnóstico 2222']
    ]
  ],
  // Ramas diagnóstico 3
  [
    // Ramas del diagnostico 31
    [
      // Ramas del diagnóstico 311
      ['Diagnóstico 3111'],
      // Ramas del diagnóstico 312
      ['Diagnóstico 3121'],
      // Ramas del diagnóstico 313
      ['Diagnóstico 3131'],
      // Ramas del diagnóstico 314
      ['Diagnóstico 3141'],
    ],
    // Ramas del diagnostico 32
    [
      // Ramas del diagnóstico 321
      ['Diagnóstico 3211'],
      // Ramas del diagnóstico 322
      ['Diagnóstico 3221'],
      // Ramas del diagnóstico 323
      ['Diagnóstico 3231'],
      // Ramas del diagnóstico 324
      ['Diagnóstico 3241'],
    ],
    // Ramas del diagnostico 33
    [
      // Ramas del diagnóstico 331
      ['Diagnóstico 3311'],
      // Ramas del diagnóstico 332
      ['Diagnóstico 3321'],
      // Ramas del diagnóstico 333
      ['Diagnóstico 3331'],
      // Ramas del diagnóstico 334
      ['Diagnóstico 3341'],
    ],
    // Ramas del diagnostico 34
    [
      // Ramas del diagnóstico 341
      ['Diagnóstico 3411'],
      // Ramas del diagnóstico 342
      ['Diagnóstico 3421'],
      // Ramas del diagnóstico 343
      ['Diagnóstico 3431'],
      // Ramas del diagnóstico 344
      ['Diagnóstico 3441'],
    ],
  ]
]; // Fin diag4

List<List<List<List<String>>>> nivel4 = [
  [
    [
      ['Diagnóstico 1111', 'Diagnóstico 1112'],
      ['Diagnóstico 1121', 'Diagnóstico 1122'],
      ['Diagnóstico 1131', 'Diagnóstico 1132', 'Diagnóstico 1133']
    ],
    [
      ['Diagnóstico 1211', 'Diagnóstico 1212'],
      ['Diagnóstico 1221', 'Diagnóstico 1222'],
      ['Diagnóstico 1231', 'Diagnóstico 1232', 'Diagnóstico 1233']
    ],
    [
      ['Diagnóstico 1311', 'Diagnóstico 1312'],
      ['Diagnóstico 1321', 'Diagnóstico 1322'],
      ['Diagnóstico 1331', 'Diagnóstico 1332', 'Diagnóstico 1333']
    ],
  ],
  [
    [
      ['Diagnóstico 2111', 'Diagnóstico 2112'],
      ['Diagnóstico 2121', 'Diagnóstico 2122'],
      ['Diagnóstico 2131', 'Diagnóstico 2132', 'Diagnóstico 2133']
    ],
    [
      ['Diagnóstico 2211', 'Diagnóstico 2212'],
      ['Diagnóstico 2221', 'Diagnóstico 2222'],
      ['Diagnóstico 2231', 'Diagnóstico 2232', 'Diagnóstico 2233']
    ],
    [
      ['Diagnóstico 2311', 'Diagnóstico 2312'],
      ['Diagnóstico 2321', 'Diagnóstico 2322'],
      ['Diagnóstico 2331', 'Diagnóstico 2332', 'Diagnóstico 2333']
    ],
  ],
  [
    [
      ['Diagnóstico 3111', 'Diagnóstico 3112'],
      ['Diagnóstico 3121', 'Diagnóstico 3122'],
      ['Diagnóstico 3131', 'Diagnóstico 3132', 'Diagnóstico 3133']
    ],
    [
      ['Diagnóstico 3211', 'Diagnóstico 3212'],
      ['Diagnóstico 3221', 'Diagnóstico 3222'],
      ['Diagnóstico 3231', 'Diagnóstico 3232', 'Diagnóstico 3233']
    ],
    [
      ['Diagnóstico 3311', 'Diagnóstico 3312'],
      ['Diagnóstico 3321', 'Diagnóstico 3322'],
      ['Diagnóstico 3331', 'Diagnóstico 3332', 'Diagnóstico 3333']
    ],
  ],
];
