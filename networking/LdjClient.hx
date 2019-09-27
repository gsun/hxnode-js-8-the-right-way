import js.node.events.EventEmitter;
class LdjClient extends EventEmitter<LdjClient> {
    public function new(stream:IEventEmitter) {
        super();
        var buffer = '';
        stream.on('data', (data) -> {
          buffer += data;
          var boundary = buffer.indexOf('\n');
          while (boundary != -1) {
            var input = buffer.substring(0, boundary);
            buffer = buffer.substring(boundary + 1);
            emit('message', haxe.Json.parse(input));
            boundary = buffer.indexOf('\n');
          }
        });
    }
    static function connect(stream:IEventEmitter) {
        return new LdjClient(stream);
    }
}