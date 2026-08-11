abstract class Repository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<void> save(T item);
  Future<void> update(T item);
  Future<void> delete(String id);
  Future<void> saveAll(List<T> items);
}