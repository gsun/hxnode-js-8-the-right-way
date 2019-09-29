import js.npm.Redis;
import js.lib.Error;
import js.node.Fs;

class RedisWatcherPub {
    static function main() {
        var args = Sys.args();
        if (args.length == 0) {
            throw new Error('Error: No filename specified.');
        }
        var filename = args[0];
        var publisher = Redis.createClient();
        var watcher = Fs.watch(filename, (e, p) -> {
                publisher.publish('pub', haxe.Json.stringify({type: 'changed', file: filename, timestamp: Date.now()}));
        });
    }
}