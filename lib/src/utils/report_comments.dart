import 'dart:math';

const reportAbuseComments = [
  'The channel undermines the integrity of the Ukrainian state. Spreading fake news, misleading people. Block him as soon as possible!',
  'This channel is spreading fake news, misleading people. Block him as soon as possible!',
  'The channel undermines the integrity of the Ukrainian state. Spreading fake news, misleading people. There are a lot of posts with threats against Ukrainians and Ukrainian soldiers. Block him ASAP!',
  'Propaganda of the war in Ukraine. Propaganda of the murder of Ukrainians and Ukrainian soldiers.',
  'Канал підриває цілісність української держави. Поширення фейкових новин, введення в оману людей. Дуже багато постів із погрозами на адресу українців та українських солдатів. Заблокуйте його якнайшвидше!',
  'Канал подрывает целостность украинского государства. Распространение фейковых новостей, введение в заблуждение людей. Очень много постов с угрозами в адрес украинцев и украинских солдат. Заблокируйте его как можно скорее!',
];

String get reportAbuseComment {
  final index = Random().nextInt(1000) % reportAbuseComments.length;
  return reportAbuseComments[index];
}
