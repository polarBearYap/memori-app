import 'package:drift/drift.dart';
import 'package:memori_app/db/tables/tables.dart';

/*
  * SyncEntity=0
  * AppUser=0
  * TimeZone=0
  *
  * CardTag=1
  * DeckSettings=1
  * DeckTag=1
  * StudyOption=1
  * 
  * Deck=2
  * StudyOptionState=2
  * StudyOptionTag=2
  * 
  * Card=3
  * DeckImage=3
  * DeckReview=3
  * DeckTagMapping=3
  * StudyOptionDeck=3
  * 
  * CardHint=4
  * CardTagMapping=4
  * ReviewLog=4
  */

int getSortOrder<T extends Table>() {
  if (T == SyncEntities) {
    return 0;
  }
  if (T == AppUsers) {
    return 0;
  }
  if (T == TimeZones) {
    return 0;
  }
  if (T == CardTags) {
    return 1;
  }
  if (T == DeckSettings) {
    return 1;
  }
  if (T == DeckTags) {
    return 1;
  }
  if (T == StudyOptions) {
    return 1;
  }
  if (T == Decks) {
    return 2;
  }
  if (T == StudyOptionStates) {
    return 2;
  }
  if (T == StudyOptionTags) {
    return 2;
  }
  if (T == Cards) {
    return 3;
  }
  if (T == DeckImages) {
    return 3;
  }
  if (T == DeckReviews) {
    return 3;
  }
  if (T == DeckTagMappings) {
    return 3;
  }
  if (T == StudyOptionDecks) {
    return 3;
  }
  if (T == CardHints) {
    return 4;
  }
  if (T == CardTagMappings) {
    return 4;
  }
  if (T == ReviewLogs) {
    return 4;
  }
  throw const FormatException('Unsupported type');
}

String getEntityName<T extends Table>() {
  if (T == SyncEntities) {
    return 'SyncEntity';
  }
  if (T == CardTags) {
    return 'CardTag';
  }
  if (T == DeckSettings) {
    return 'DeckSettings';
  }
  if (T == DeckTags) {
    return 'DeckTag';
  }
  if (T == StudyOptions) {
    return 'StudyOption';
  }
  if (T == Decks) {
    return 'Deck';
  }
  if (T == StudyOptionStates) {
    return 'StudyOptionState';
  }
  if (T == StudyOptionTags) {
    return 'StudyOptionTag';
  }
  if (T == Cards) {
    return 'Card';
  }
  if (T == DeckImages) {
    return 'DeckImage';
  }
  if (T == DeckReviews) {
    return 'DeckReview';
  }
  if (T == DeckTagMappings) {
    return 'DeckTagMapping';
  }
  if (T == StudyOptionDecks) {
    return 'StudyOptionDeck';
  }
  if (T == CardHints) {
    return 'CardHint';
  }
  if (T == CardTagMappings) {
    return 'CardTagMapping';
  }
  if (T == ReviewLogs) {
    return 'ReviewLog';
  }
  throw const FormatException('Unsupported type');
}
