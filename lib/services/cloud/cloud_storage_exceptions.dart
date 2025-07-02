class CloudStorageExceptions implements Exception {
  const CloudStorageExceptions();
}

class CouldNotCeateNoteException extends CloudStorageExceptions {}

class CouldNotGetAllNotesException extends CloudStorageExceptions {}

class CouldNotUpdateNoteException extends CloudStorageExceptions {}

class CouldNotDeleteNoteException extends CloudStorageExceptions {}
