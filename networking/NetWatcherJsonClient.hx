import js.node.Net;
class NetWatcherJsonClient {
    static function main() {
        var client = Net.connect(60300);
        client.on('data', (data) -> {
            var message = haxe.Json.parse(data);
            if (message.type == 'watching') {
                trace('Now watching: ${message.file}');
            } else if (message.type == 'changed') {
                trace('File changed: ${message.timestamp}');
            } else {
                trace('Unrecognized message type: ${message.type}');
            }
        });
    }
}