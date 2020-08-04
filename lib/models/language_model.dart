class Language {
  final int id;
  final String name;
  final String languageCode;
  final String languageFlag;

  Language(this.id, this.name, this.languageCode, this.languageFlag);

  static List<Language> getLanguages() {
    return <Language>[
      Language(1, 'Français', 'fr','🇫🇷'),
      Language(2, 'English', 'en','🇬🇧'),
    ];
  }
}
