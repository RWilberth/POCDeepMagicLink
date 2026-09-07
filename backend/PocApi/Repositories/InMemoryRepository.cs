using System.Collections.Concurrent;

namespace PocApi.Repositories;

public interface IEntity
{
    int Id { get; set; }
}

public class InMemoryRepository<T> where T : class, IEntity
{
    private readonly ConcurrentDictionary<int, T> _items = new();
    private int _nextId = 0;

    public IEnumerable<T> GetAll() => _items.Values.OrderBy(i => i.Id).ToList();

    public T? GetById(int id) => _items.GetValueOrDefault(id);

    public T Add(T item)
    {
        item.Id = Interlocked.Increment(ref _nextId);
        _items[item.Id] = item;
        return item;
    }

    public bool Update(int id, T item)
    {
        if (!_items.ContainsKey(id)) return false;
        item.Id = id;
        _items[id] = item;
        return true;
    }

    public bool Delete(int id) => _items.TryRemove(id, out _);
}
