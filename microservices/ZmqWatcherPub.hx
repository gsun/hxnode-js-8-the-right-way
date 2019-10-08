import js.lib.Error;
import js.node.Fs;
import js.node.buffer.Buffer;

class ZmqWatcherPub {
    static function main() {
        var args = Sys.args();
        if (args.length == 0) {
            throw new Error('Error: No filename specified.');
        }
        var filename = args[0];
        var publisher = new Zeromq.Socket('pub');
        var watcher = Fs.watch(filename, (e, p) -> {
            var message = haxe.Json.stringify({type: 'changed', file: filename, timestamp: Date.now()});
            publisher.send(Buffer.from(message, 'utf8'));
        });
        publisher.bind('tcp://*:60400');
    }
}