import 'package:edt/module/home/model/photo/photo_model.dart';

import '../model/collection/collection_model.dart';

abstract class HomeRepository {
  Future<List<CollectionItemModel>> getCollections(int perPage);

  Future<List<PhotoItemModel>> getPhotos(int page, int perPage);
}
