import js.node.Net;
class TestJsonService {
    static function main() {
        Net.createServer((connection) -> {
            trace('Subscriber connected.');
            var message = haxe.Json.stringify({type: "changed", timestamp: Date.now()}) + '\n';
            var firstChunk = message.substring(0, 10);
            var secondChunk = message.substring(10, message.length);
            
            connection.write(firstChunk);
            
            var timer = js.Node.setTimeout(() -> {
                connection.write(secondChunk);
                connection.end();
            }, 100);
            connection.on('close', () -> {
                js.Node.clearTimeout(timer);
                trace('Subscriber disconnected.');
                
            });
        }).listen(60300, () -> trace('Listening for subscribers...'));
    }
}