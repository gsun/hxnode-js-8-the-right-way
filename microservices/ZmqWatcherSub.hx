import js.lib.Error;
import js.node.buffer.Buffer;

class ZmqWatcherSub {
    static function main() {
        var subscriber = new Zeromq.Socket('sub');
        subscriber.subscribe('');
        subscriber.on('message', (data) -> {
            var message = haxe.Json.parse(data);
            trace('File "${message.file}" changed at ${message.timestamp}');
        });
        subscriber.connect("tcp://localhost:60400");
    }
}