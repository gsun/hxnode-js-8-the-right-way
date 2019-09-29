import js.npm.Redis;

class RedisWatcherSub {
    static function main() {
        var subscriber = Redis.createClient();
        subscriber.on('message', (channel, data) -> {
            var message = haxe.Json.parse(data);
            trace('Channel "${channel}" message: File "${message.file}" changed at ${message.timestamp}');
        });
        subscriber.subscribe('pub');
    }
}